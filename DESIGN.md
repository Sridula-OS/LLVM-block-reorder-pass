# Design Approach

This project implements a heuristic-based LLVM basic block layout optimization. The pass uses static compiler analyses to identify hot successor edges and then reorders basic blocks so the hottest successor is placed immediately after the current block where possible. This improves the chance that the common path becomes a fall-through path instead of a taken branch.

The optimization is intentionally local and conservative. It does not attempt whole-program layout or full trace construction. Instead, it focuses on each function independently and uses the control-flow information already available inside LLVM.

# Why BPI + BFI

The pass combines two LLVM analyses:

- `BranchProbabilityInfo` estimates how likely each outgoing edge is to be taken.
- `BlockFrequencyInfo` estimates how frequently each destination block executes.

Using only branch probability can overvalue a likely edge in a rarely executed block. Using only block frequency can ignore which successor is preferred at a branch. The combined score gives a better heuristic:

```text
score = branch_probability x block_frequency
```

This means a successor is treated as hot when it is both likely to be selected and important in the execution profile estimated by LLVM.

# Reordering Strategy

The pass uses a local greedy strategy:

1. Visit each basic block in a function.
2. Inspect all successor edges from the terminator instruction.
3. Compute a score for each successor using branch probability and successor block frequency.
4. Select the successor with the highest score.
5. Move that successor immediately after the current block using LLVM's basic block list `splice()` if it is not already the fall-through block.

The intended result is fall-through optimization: the hot path is laid out contiguously, while colder paths are more likely to require taken branches.

# Alternatives Considered

- Profile-guided optimization: This can give more accurate hot-path information, but it requires runtime profiles and extra build steps.
- Trace scheduling: This can find longer hot traces, but it is more complex and can disturb more of the function layout.
- Machine learning predictors: These may learn better branch patterns, but they require training data and add unnecessary complexity for this assignment.
- Static compiler heuristics: LLVM already provides static branch and block-frequency estimates, so this project builds on those analyses instead of creating a separate predictor.

# Tradeoffs

This optimization can improve fall-through behavior, but it is still a heuristic. It may hurt instruction-cache locality if moving blocks separates code that was better kept together. It may also fail on unpredictable branches where static probabilities do not match real execution. Since the strategy is local and greedy, it does not guarantee a globally optimal function layout.
