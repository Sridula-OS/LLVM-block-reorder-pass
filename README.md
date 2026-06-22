# LLVM Basic Block Reordering Pass

## Project Overview

This project implements an LLVM new pass manager `FunctionPass` that reorders basic blocks to improve hot-path fall-through behavior and reduce estimated taken branches.

The pass uses LLVM's `BranchProbabilityInfo` and `BlockFrequencyInfo` analyses to identify the hottest successor of each basic block. If that successor is not already physically adjacent to the current block, the pass moves it using LLVM's basic block list `splice()` operation.

The evaluation includes both scalar control-flow programs and programs built
around structures and common data structures. The pass does not reorder fields
inside a C structure. It optimizes the basic blocks produced by operations such
as structure-field checks, array traversal, pointer chasing, recursion, and
stack/queue processing.

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
- Linux, WSL, or Docker Desktop

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
|-- run_docker.ps1
|-- Dockerfile
|-- test.c
|-- test1.c
|-- test2.c
|-- test3.c
|-- test4.c
|-- test5_struct.c
|-- test6_array.c
|-- test7_linked_list.c
|-- test8_tree.c
|-- test9_stack_queue.c
|-- results/
|   |-- *.ll
|   |-- *_out.ll
|   |-- *_before.png
|   |-- *_after.png
|   |-- *_log.txt
|   |-- *_verification.txt
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
    -S test.ll -o test_out.ll
```

## Automatic Evaluation

Run:

```bash
./run_all.sh
```

The script:

- Builds the LLVM pass.
- Compiles all ten test cases to LLVM IR.
- Generates before CFG PNGs.
- Runs the block reorder pass.
- Runs LLVM's IR verifier after the transformation.
- Compiles and executes before/after IR when a test has `main`.
- Fails if observable program output changes.
- Generates after CFG PNGs.
- Writes per-test logs.
- Copies representative demo artifacts into `screenshots/`.

The transformed files are emitted as textual LLVM IR using `opt -S`, so the
`*_out.ll` extension now matches the file contents.

## Docker Evaluation

If LLVM 14 is not installed locally, run the complete suite through Docker:

```powershell
.\run_docker.ps1
```

This builds a pinned Ubuntu 22.04 image containing LLVM/Clang 14, CMake,
Graphviz, and the required build tools. Container builds use `build-docker/`
to avoid conflicting with a host-side CMake cache.

The runner deletes each generated test artifact before recreating it. This
avoids WSL DrvFs overwrite errors when previous outputs were produced through
Docker in the same Windows-mounted directory.

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
| test5_struct | Array of `Student` structures and field-based branches |
| test6_array | Array traversal with nested value classification |
| test7_linked_list | Pointer-chasing `while` loop over linked nodes |
| test8_tree | Recursive binary-tree traversal |
| test9_stack_queue | Stack and queue structures with multiple processing loops |

## Documentation

Additional required project documentation is provided in:

- `DESIGN.md`
- `IMPLEMENTATION.md`
- `EVALUATION.md`

## Known Limitations

This is a static heuristic optimization. It can be less effective when branches are unpredictable, when static branch estimates do not match real runtime behavior, or when local reordering hurts instruction-cache locality.

A valid test can also produce zero reorders when Clang has already placed the
estimated hot successors next to their predecessors. `test8_tree.c` currently
demonstrates this no-op case.
