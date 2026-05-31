# LLVM Basic Block Reordering Pass

## Project Overview

This project implements an LLVM new pass manager `FunctionPass` that reorders basic blocks to improve hot-path fall-through behavior and reduce estimated taken branches.

The pass uses LLVM's `BranchProbabilityInfo` and `BlockFrequencyInfo` analyses to identify the hottest successor of each basic block. If that successor is not already physically adjacent to the current block, the pass moves it using LLVM's basic block list `splice()` operation.

## Objective

- Use `BranchProbabilityInfo` to estimate successor edge likelihood.
- Use `BlockFrequencyInfo` to estimate basic block execution frequency.
- Combine BPI and BFI into a hot-successor score.
- Reorder hot successors after the current block for fall-through optimization.
- Preserve PHI incoming mappings after layout changes.
- Generate before/after CFG diagrams and logs for evaluation.

## Technologies Used

- LLVM 14 tested in WSL/Ubuntu
- Clang
- CMake
- C++
- Graphviz
- Linux or WSL

## Project Structure

```text
LLVM-block-reorder-pass/
|-- BlockReorderPass.cpp
|-- CMakeLists.txt
|-- README.md
|-- DESIGN.md
|-- IMPLEMENTATION.md
|-- EVALUATION.md
|-- run_all.sh
|-- test.c
|-- test1.c
|-- test2.c
|-- test3.c
|-- test4.c
|-- results/
|   |-- *.ll
|   |-- *_out.ll
|   |-- *_before.png
|   |-- *_after.png
|   |-- *_log.txt
|-- screenshots/
|   |-- before-cfg-test3.png
|   |-- after-cfg-test3.png
|   |-- failure-test4-before.png
|   |-- failure-test4-after.png
|   |-- terminal-output.png
|   |-- terminal-output.txt
|-- build/
```

## Build Instructions

Install the required tools:

```bash
sudo apt install llvm clang cmake build-essential graphviz
```

Build the pass:

```bash
mkdir -p build
cd build
cmake ..
make
```

## Running One Test

Compile a test case to LLVM IR:

```bash
clang -O1 -S -emit-llvm test.c -o test.ll
```

Run the pass:

```bash
opt -load-pass-plugin ./build/libBlockReorderPass.so \
    -passes="block-reorder" \
    test.ll -o test_out.ll
```

## Automatic Evaluation

Run:

```bash
./run_all.sh
```

The script:

- Builds the LLVM pass.
- Compiles all five test cases to LLVM IR.
- Generates before CFG PNGs.
- Runs the block reorder pass.
- Generates after CFG PNGs.
- Writes per-test logs.
- Copies representative demo artifacts into `screenshots/`.

## Implementation Summary

For each function, the pass:

1. Gets `BranchProbabilityInfo` and `BlockFrequencyInfo`.
2. Iterates over each basic block with successor edges.
3. Computes a hotness score for each successor:

```text
score = branch_probability x block_frequency
```

4. Selects the highest-scoring successor.
5. Moves that successor after the current block with basic block list `splice()` when it is safe and useful.
6. Reconstructs PHI incoming mappings.
7. Prints branch and reordering metrics.

## Test Cases

| Test  | Purpose |
| ----- | ------- |
| test  | Simple conditionals with loop behavior |
| test1 | Multiple conditional branches |
| test2 | Loop-heavy control flow |
| test3 | Nested branches and cold paths |
| test4 | Unpredictable branch behavior/failure case |

## Documentation

Additional required project documentation is provided in:

- `DESIGN.md`
- `IMPLEMENTATION.md`
- `EVALUATION.md`

## Known Limitations

This is a static heuristic optimization. It can be less effective when branches are unpredictable, when static branch estimates do not match real runtime behavior, or when local reordering hurts instruction-cache locality.
