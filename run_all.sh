#!/bin/bash

echo "===== Building LLVM Pass ====="

cd build
cmake ..
make
cd ..

# Create results directory if not exists
mkdir -p results

echo ""
echo "===== Running All Test Cases ====="

for file in test test1 test2 test3 test4
do
    echo ""
    echo "==============================="
    echo "Processing $file"
    echo "==============================="

    # -----------------------------------
    # Compile C -> LLVM IR
    # -----------------------------------
    clang -O1 -S -emit-llvm $file.c -o results/$file.ll

    echo "Generated results/$file.ll"

    # -----------------------------------
    # BEFORE CFG
    # -----------------------------------
    rm -f .*.dot

    opt -passes=dot-cfg results/$file.ll -disable-output

    for dotfile in .*.dot
    do
        dot -Tpng "$dotfile" -o "results/${file}_before.png"
        rm "$dotfile"
        break
    done

    echo "Generated results/${file}_before.png"

    # -----------------------------------
    # Run LLVM Pass
    # -----------------------------------
    opt -load-pass-plugin ./build/libBlockReorderPass.so \
        -passes="block-reorder" \
        results/$file.ll -o results/${file}_out.ll \
        2> results/${file}_log.txt

    echo "Generated results/${file}_out.ll"

    # -----------------------------------
    # AFTER CFG
    # -----------------------------------
    rm -f .*.dot

    opt -passes=dot-cfg results/${file}_out.ll -disable-output

    for dotfile in .*.dot
    do
        dot -Tpng "$dotfile" -o "results/${file}_after.png"
        rm "$dotfile"
        break
    done

    echo "Generated results/${file}_after.png"

done

echo ""
echo "===== ALL TESTS COMPLETED ====="
echo "Results stored inside results/"
