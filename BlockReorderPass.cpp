#include "llvm/ADT/SmallVector.h"
#include "llvm/Analysis/BlockFrequencyInfo.h"
#include "llvm/Analysis/BranchProbabilityInfo.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"

#include <iterator>
#include <utility>

using namespace llvm;

namespace {

struct BlockReorderPass : public PassInfoMixin<BlockReorderPass> {
    void printBlockName(BasicBlock *BB) {
        if (BB->hasName())
            errs() << BB->getName();
        else
            errs() << "(unnamed_" << BB << ")";
    }

    void fixPHINodes(Function &F) {
        for (auto &BB : F) {
            for (auto &I : BB) {
                auto *PN = dyn_cast<PHINode>(&I);

                if (!PN)
                    continue;

                SmallVector<std::pair<Value *, BasicBlock *>, 8> Incoming;

                for (unsigned i = 0; i < PN->getNumIncomingValues(); i++) {
                    Incoming.push_back({
                        PN->getIncomingValue(i),
                        PN->getIncomingBlock(i)
                    });
                }

                while (PN->getNumIncomingValues() > 0)
                    PN->removeIncomingValue((unsigned)0, false);

                for (auto &Entry : Incoming)
                    PN->addIncoming(Entry.first, Entry.second);
            }
        }
    }

    PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM) {
        auto &BPI = AM.getResult<BranchProbabilityAnalysis>(F);
        auto &BFI = AM.getResult<BlockFrequencyAnalysis>(F);

        errs() << "\n=====================================\n";
        errs() << "Processing Function: " << F.getName() << "\n";
        errs() << "=====================================\n";

        int TotalBranches = 0;
        int ReorderedBranches = 0;

        for (auto &BB : F) {
            auto *Term = BB.getTerminator();

            if (!Term)
                continue;

            errs() << "\nBasicBlock: ";
            printBlockName(&BB);
            errs() << "\n";

            uint64_t BlockFreq = BFI.getBlockFreq(&BB).getFrequency();

            errs() << "  Block Frequency: " << BlockFreq << "\n";

            unsigned NumSuccessors = Term->getNumSuccessors();

            if (NumSuccessors == 0) {
                errs() << "  No successor edges to analyze\n";
                continue;
            }

            TotalBranches++;

            BasicBlock *BestSucc = nullptr;
            uint64_t BestScore = 0;

            for (unsigned i = 0; i < NumSuccessors; i++) {
                BasicBlock *Succ = Term->getSuccessor(i);
                auto Prob = BPI.getEdgeProbability(&BB, Succ);
                uint64_t SuccFreq = BFI.getBlockFreq(Succ).getFrequency();

                // Combined heuristic: branch probability x execution frequency.
                uint64_t Score = Prob.getNumerator() * SuccFreq;

                errs() << "  Successor: ";
                printBlockName(Succ);
                errs() << " | Probability: " << Prob;
                errs() << " | Frequency: " << SuccFreq;
                errs() << " | Score: " << Score << "\n";

                if (Score > BestScore) {
                    BestScore = Score;
                    BestSucc = Succ;
                }
            }

            if (BestSucc) {
                errs() << "  --> Hot Successor: ";
                printBlockName(BestSucc);
                errs() << "\n";
            }

            if (BestSucc &&
                BestSucc != &BB &&
                BestSucc != &F.getEntryBlock() &&
                BestSucc != BB.getNextNode()) {
                errs() << "  *** Reordering: ";
                printBlockName(&BB);
                errs() << " -> ";
                printBlockName(BestSucc);
                errs() << "\n";
                errs() << "  ;; Reordered edge reduces taken branch\n";

                auto InsertPt = std::next(BB.getIterator());
                auto &Blocks = F.getBasicBlockList();
                Blocks.splice(InsertPt, Blocks, BestSucc->getIterator());

                ReorderedBranches++;
            }
        }

        fixPHINodes(F);

        errs() << "\n=====================================\n";
        errs() << "Optimization Summary\n";
        errs() << "=====================================\n";
        errs() << "Total branches analyzed: " << TotalBranches << "\n";
        errs() << "Blocks reordered: " << ReorderedBranches << "\n";
        errs() << "Estimated taken branch reduction: "
               << ReorderedBranches << "\n";

        return PreservedAnalyses::none();
    }
};

} // namespace

extern "C" LLVM_ATTRIBUTE_WEAK llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
    return {
        LLVM_PLUGIN_API_VERSION,
        "block-reorder-pass",
        "v0.1",
        [](llvm::PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](llvm::StringRef Name,
                   llvm::FunctionPassManager &FPM,
                   llvm::ArrayRef<
                       llvm::PassBuilder::PipelineElement>) {
                    if (Name == "block-reorder") {
                        FPM.addPass(BlockReorderPass());
                        return true;
                    }

                    return false;
                });
        }
    };
}
