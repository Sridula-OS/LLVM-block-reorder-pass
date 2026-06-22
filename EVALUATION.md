# Test Cases

| Test  | Type |
| ----- | ---- |
| test  | Simple conditionals with a loop |
| test1 | Nested/serial branches |
| test2 | Loops with conditional updates |
| test3 | Cold paths and nested conditionals |
| test4 | Unpredictable branches |
| test5_struct | Array of structures and field-based decisions |
| test6_array | Array traversal and nested classification |
| test7_linked_list | Linked-list pointer chasing |
| test8_tree | Recursive binary-tree traversal |
| test9_stack_queue | Stack and queue processing |

# Metrics

The repository contains generated logs in `results/`. The latest `./run_all.sh` execution produced the following metrics:

| Test  | Branches | Reordered | Reduction |
| ----- | -------- | --------- | --------- |
| test  | 2 | 1 | 1 |
| test1 | 3 | 2 | 2 |
| test2 | 2 | 1 | 1 |
| test3 | 7 | 4 | 4 |
| test4 | 2 | 1 | 1 |
| test5_struct | 9 | 7 | 7 |
| test6_array | 10 | 9 | 9 |
| test7_linked_list | 7 | 4 | 4 |
| test8_tree | 2 | 0 | 0 |
| test9_stack_queue | 13 | 9 | 9 |

These values were produced with LLVM/Clang 14 in the repository's Ubuntu 22.04
Docker environment. They can be refreshed using `./run_all.sh` on Linux/WSL or
`.\run_docker.ps1` on a Docker-enabled Windows machine. The script writes
per-test logs to `results/*_log.txt`.

# Correctness Verification

All transformed modules passed LLVM's IR verifier. All tests containing a
`main` function produced identical output before and after the pass.

| Test | Program output |
| ---- | -------------- |
| test | -35 |
| test5_struct | 109 |
| test6_array | 121 |
| test7_linked_list | 24 |
| test8_tree | 19 |
| test9_stack_queue | 97 |

The older helper-only tests (`test1` through `test4`) have no `main`, so they
receive IR verification but not executable output comparison.

# Data-Structure Interpretation

The new tests show that this pass applies to code using aggregate data
structures because their operations generate branches and basic blocks. The
optimization still concerns CFG layout. It does not modify the memory layout of
the structures themselves.

`test8_tree` is a useful no-op case: the recursive tree function is valid and
analyzed, but LLVM's existing block order already matches the selected hot
successors, so no block move is required.

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
- `screenshots/structure-before.png`
- `screenshots/structure-after.png`
- `screenshots/linked-list-before.png`
- `screenshots/linked-list-after.png`
