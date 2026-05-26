# LLVM Basic Block Reordering Pass for Branch Optimization

## Project Overview

This project implements an LLVM FunctionPass that performs **basic block reordering** to improve branch prediction and reduce taken branches using **fall-through optimization**.

The pass analyzes branch probabilities and block execution frequencies to identify the most likely execution paths and rearranges basic blocks accordingly.

---

## Objective

The objective of this project is to:

- Use `BranchProbabilityInfo (BPI)` to identify hot successor edges
- Use `BlockFrequencyInfo (BFI)` to estimate execution frequencies
- Reorder basic blocks so hot successors become fall-through paths
- Handle PHI nodes safely after reordering
- Estimate reduction in taken branches
- Generate CFG diagrams before and after optimization

---

## Technologies Used

- LLVM 21
- Clang
- C++
- CMake
- Graphviz
- Ubuntu (WSL)

---

## Features Implemented

### Branch Probability Analysis
The pass uses:

```cpp
BranchProbabilityInfo
```

to determine the probability of each successor edge.

---

### Block Frequency Analysis
The pass uses:

```cpp
BlockFrequencyInfo
```

to estimate how frequently each basic block executes.

---

### Basic Block Reordering
Hot successor blocks are moved immediately after the current block using:

```cpp
moveAfter()
```

This improves fall-through execution and reduces taken branches.

---

### PHI Node Handling
The pass reconstructs PHI node incoming mappings safely after block reordering.

---

### Performance Metrics
The pass prints:

- Block frequencies
- Branch probabilities
- Reordered edges
- Estimated taken branch reduction

---

## Project Structure

```text
llvm-pass/
│
├── BlockReorderPass.cpp
├── CMakeLists.txt
├── run_all.sh
│
├── test.c
├── test1.c
├── test2.c
├── test3.c
│
├── results/
│   ├── CFG images
│
└── build/
```

---

# Build Instructions

## 1. Install Dependencies

```bash
sudo apt install llvm clang cmake build-essential graphviz
```

---

## 2. Build the LLVM Pass

```bash
mkdir build
cd build

cmake ..
make
```

---

# Running the Pass

## Compile test file to LLVM IR

```bash
clang -O1 -S -emit-llvm test.c -o test.ll
```

---

## Run LLVM Pass

```bash
opt -load-pass-plugin ./build/libBlockReorderPass.so \
    -passes="block-reorder" \
    test.ll -disable-output
```

---

# Automatic Testing

The script `run_all.sh` automatically:

- Compiles all test files
- Runs the LLVM pass
- Generates CFG diagrams
- Produces before/after PNG images

Run:

```bash
./run_all.sh
```

---

# CFG Visualization

CFG diagrams are generated using LLVM DOT graph generation and Graphviz.

Generated results are include:

```text
- LLVM IR files
- Optimized IR files
- CFG diagrams
- Execution logs
```

---

# Test Cases

The project includes multiple test cases featuring:

- Conditional branches
- Nested conditionals
- Loops
- Cold error-handling paths
- Cases where reordering may hurt performance

---

# Example Output

The pass prints:

- Branch probabilities
- Block frequencies
- Hot successor selection
- Reordering decisions
- Estimated branch reduction

Example:

```text
*** Reordering: if.then -> loop.body
;; Reordered edge reduces taken branch
```

---

# When Block Reordering Can Hurt Performance

Block reordering may degrade performance when:

- Incorrect branch prediction heuristics are used
- Cold paths are mistakenly treated as hot
- Instruction cache locality worsens
- Excessive reordering disrupts layout stability
