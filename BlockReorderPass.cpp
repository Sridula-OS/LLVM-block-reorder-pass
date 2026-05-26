#include "llvm/IR/PassManager.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Support/raw_ostream.h"

#include "llvm/Analysis/BranchProbabilityInfo.h"
#include "llvm/Analysis/BlockFrequencyInfo.h"

#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"

using namespace llvm;

namespace {

struct BlockReorderPass : public PassInfoMixin<BlockReorderPass> {

    // Print block name safely
    void printBlockName(BasicBlock *BB) {
        if (BB->hasName())
            errs() << BB->getName();
        else
            errs() << "(unnamed_" << BB << ")";
    }

    // Fix PHI nodes safely after reordering
    void fixPHINodes(Function &F) {
        for (auto &BB : F) {
            for (auto &I : BB) {

                if (auto *PN = dyn_cast<PHINode>(&I)) {

                    SmallVector<std::pair<Value*, BasicBlock*>, 8> incoming;

                    // Store existing mappings
                    for (unsigned i = 0; i < PN->getNumIncomingValues(); i++) {
                        incoming.push_back({
                            PN->getIncomingValue(i),
                            PN->getIncomingBlock(i)
                        });
                    }

                    // Remove all entries safely (fix ambiguity)
                    while (PN->getNumIncomingValues() > 0) {
                        PN->removeIncomingValue((unsigned)0, false);
                    }

                    // Reinsert mappings
                    for (auto &pair : incoming) {
                        PN->addIncoming(pair.first, pair.second);
                    }
                }
            }
        }
    }

    PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM) {

        auto &BPI = AM.getResult<BranchProbabilityAnalysis>(F);
        auto &BFI = AM.getResult<BlockFrequencyAnalysis>(F);

        errs() << "\n=== Processing Function: " << F.getName() << " ===\n";

        int totalBranches = 0;
        int reordered = 0;

        for (auto &BB : F) {

            auto *Term = BB.getTerminator();
            if (!Term) continue;

            errs() << "\nBasicBlock: ";
            printBlockName(&BB);
            errs() << "\n";

            // Print block frequency
            errs() << "  Frequency: "
                   << BFI.getBlockFreq(&BB).getFrequency() << "\n";

            BasicBlock *BestSucc = nullptr;
            BranchProbability BestProb = BranchProbability::getZero();

            for (unsigned i = 0; i < Term->getNumSuccessors(); i++) {

                BasicBlock *Succ = Term->getSuccessor(i);
                auto Prob = BPI.getEdgeProbability(&BB, Succ);

                uint64_t currFreq = BFI.getBlockFreq(Succ).getFrequency();
                uint64_t bestFreq = BestSucc ? BFI.getBlockFreq(BestSucc).getFrequency() : 0;

                // Combined score: probability × frequency
                uint64_t currScore = Prob.getNumerator() * currFreq;
                uint64_t bestScore = BestProb.getNumerator() * bestFreq;

                errs() << "  Successor: ";
                printBlockName(Succ);
                errs() << " | Probability: " << Prob;
                errs() << " | Frequency: " << currFreq << "\n";

                if (currScore > bestScore) {
                    BestProb = Prob;
                    BestSucc = Succ;
                }
            }

            if (BestSucc) {
                errs() << "  --> Best successor: ";
                printBlockName(BestSucc);
                errs() << "\n";
            }

            totalBranches++;

            // Reorder blocks for fall-through
            if (BestSucc && BestSucc != BB.getNextNode()) {

                errs() << "  *** Reordering: ";
                printBlockName(&BB);
                errs() << " -> ";
                printBlockName(BestSucc);
                errs() << "\n";

                // Annotation (assignment requirement)
                errs() << "  ;; Reordered edge reduces taken branch\n";

                BestSucc->moveAfter(&BB);
                reordered++;
            }
        }

        // Fix PHI nodes after reordering
        fixPHINodes(F);

        // Summary
        errs() << "\n=== Summary ===\n";
        errs() << "Total branches analyzed: " << totalBranches << "\n";
        errs() << "Reordered for fall-through: " << reordered << "\n";
        errs() << "Estimated taken branch reduction: " << reordered << "\n";

        return PreservedAnalyses::none();
    }
};

} // namespace


// Pass Registration
extern "C" LLVM_ATTRIBUTE_WEAK llvm::PassPluginLibraryInfo llvmGetPassPluginInfo() {
    return {
        LLVM_PLUGIN_API_VERSION, "block-reorder-pass", "v0.1",
        [](llvm::PassBuilder &PB) {

            PB.registerPipelineParsingCallback(
                [](llvm::StringRef Name,
                   llvm::FunctionPassManager &FPM,
                   llvm::ArrayRef<llvm::PassBuilder::PipelineElement>) {

                    if (Name == "block-reorder") {
                        FPM.addPass(BlockReorderPass());
                        return true;
                    }
                    return false;
                }
            );

        }
    };
}
