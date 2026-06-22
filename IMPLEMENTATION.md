# LLVM Pass Structure

The implementation is an LLVM new pass manager plugin. The pass is defined as:

```cpp
struct BlockReorderPass : public PassInfoMixin<BlockReorderPass>
```

It runs as a `FunctionPass`, so LLVM invokes it independently for each function. The plugin registers the pipeline name:

```text
block-reorder
```

The pass can be loaded with `opt` using:

```bash
opt -load-pass-plugin ./build/libBlockReorderPass.so \
    -passes="block-reorder" -S input.ll -o output.ll
```

# Analyses Used

The pass requests two function analyses from the `FunctionAnalysisManager`:

```cpp
auto &BPI = AM.getResult<BranchProbabilityAnalysis>(F);
auto &BFI = AM.getResult<BlockFrequencyAnalysis>(F);
```

`BranchProbabilityInfo` provides the likelihood of each control-flow edge. `BlockFrequencyInfo` estimates how frequently each basic block executes. Together, they provide a stronger signal than either analysis alone.

# Successor Selection

For every basic block with successor edges, the pass evaluates all successors of the terminator instruction. The score is:

```text
score = branch_probability x block_frequency
```

In code, the probability numerator is multiplied by the successor block frequency:

```cpp
uint64_t Score = Prob.getNumerator() * SuccFreq;
```

The successor with the highest score is selected as the hot successor.

# Reordering

If the hot successor is not already the next block in function layout, the pass moves it immediately after the current block:

```cpp
auto InsertPt = std::next(BB.getIterator());
auto &Blocks = F.getBasicBlockList();
Blocks.splice(InsertPt, Blocks, BestSucc->getIterator());
```

This uses LLVM's underlying basic block list `splice()` operation, which is compatible with the LLVM 14 packages available on Ubuntu 22.04. It changes the physical order of basic blocks in the LLVM IR function without changing the CFG edges. The goal is to make the hot successor the fall-through layout target.

The implementation first stores the function's original blocks in a
`SmallVector`. Reordering mutates LLVM's block list, so iterating the live list
directly could cause a moved block to be visited more than once. Traversing the
snapshot ensures that each original block is analyzed exactly once.

Unnamed blocks are logged with stable per-function labels such as `bb#0` and
`bb#1`. LLVM's printed numeric operands can change when block layout changes,
so the stable labels make before/after decisions easier to follow.

# PHI Node Reconstruction

Reordering basic blocks should not change PHI semantics because PHI incoming values are tied to predecessor blocks, not textual layout. The pass still includes a defensive PHI reconstruction step:

1. Store each PHI node's incoming value and incoming block mapping.
2. Remove existing incoming entries.
3. Reinsert the saved mappings.

This keeps PHI incoming block references explicit after layout changes and makes the assignment's PHI-handling requirement visible in the implementation.

# CFG Generation

The script generates CFG diagrams before and after the pass using LLVM's DOT CFG printer:

```bash
opt -passes=dot-cfg input.ll -disable-output
```

Graphviz converts the generated DOT file to PNG:

```bash
dot -Tpng input.dot -o output.png
```

The generated PNGs are stored in `results/`, and representative copies are placed in `screenshots/` for submission/demo use.

# Verification

`run_all.sh` runs the LLVM verifier after every transformation:

```bash
opt -passes=verify output.ll -disable-output
```

For tests containing `main`, the script also compiles and executes the IR before
and after the pass. It compares their standard output and stops immediately if
behavior changes. Each result is recorded in:

```text
results/<test>_verification.txt
```

The verification log also records `getelementptr` and named structure-type
counts as evidence that the aggregate-oriented tests contain real
data-structure access in LLVM IR.
