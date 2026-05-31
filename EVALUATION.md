# Test Cases

| Test  | Type |
| ----- | ---- |
| test  | Simple conditionals with a loop |
| test1 | Nested/serial branches |
| test2 | Loops with conditional updates |
| test3 | Cold paths and nested conditionals |
| test4 | Unpredictable branches |

# Metrics

The repository contains generated logs in `results/`. The latest `./run_all.sh` execution produced the following metrics:

| Test  | Branches | Reordered | Reduction |
| ----- | -------- | --------- | --------- |
| test  | 2 | 1 | 1 |
| test1 | 3 | 2 | 2 |
| test2 | 2 | 1 | 1 |
| test3 | 11 | 6 | 6 |
| test4 | 2 | 1 | 1 |

These values can be refreshed by running `./run_all.sh` in a Linux/WSL environment with LLVM, Clang, CMake, and Graphviz installed. The script writes per-test logs to `results/*_log.txt`.

# Baseline Comparison

Before the pass, block layout follows the order produced by Clang and LLVM's earlier optimization pipeline. That order may not place the hottest successor immediately after each branch.

After the pass, each analyzed basic block selects the hottest successor using the BPI and BFI score. When possible, that successor is moved after the current block so the likely path becomes the fall-through layout. This is expected to reduce taken branches when the selected hot successor was not already adjacent.

# Failure Case

`test4.c` is the failure-oriented test case. It uses a parity condition inside a loop:

```c
if ((x * y + i) % 2)
```

This branch is intentionally difficult for static heuristics because the outcome can alternate or depend heavily on runtime inputs. The pass still performs one layout reorder in the current static analysis result, but the real runtime benefit is uncertain because the data-dependent branch may not have a stable hot successor.

# Screenshots

CFG screenshots are stored in `results/` and representative submission screenshots are stored in `screenshots/`.

Important artifacts:

- `results/test3_before.png`
- `results/test3_after.png`
- `results/test4_before.png`
- `results/test4_after.png`
- `screenshots/terminal-output.png`
- `screenshots/before-cfg-test3.png`
- `screenshots/after-cfg-test3.png`
- `screenshots/failure-test4-before.png`
- `screenshots/failure-test4-after.png`
