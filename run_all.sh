#!/bin/bash

echo "===== Building LLVM Pass ====="

cd build
cmake ..
make
cd ..

echo ""
echo "===== Running All Test Cases ====="

for file in test test1 test2 test3
do
    echo ""
    echo "==============================="
    echo "Processing $file"
    echo "==============================="

    # Compile C -> LLVM IR
    clang -O1 -S -emit-llvm $file.c -o $file.ll

    echo "Generated $file.ll"

    # -----------------------------
    # BEFORE CFG
    # -----------------------------
    rm -f .*.dot

    opt -passes=dot-cfg $file.ll -disable-output

    for dotfile in .*.dot
    do
        dot -Tpng "$dotfile" -o "${file}_before.png"
        break
    done

    echo "Generated ${file}_before.png"

    # -----------------------------
    # Run LLVM Pass
    # -----------------------------
    opt -load-pass-plugin ./build/libBlockReorderPass.so \
        -passes="block-reorder" \
        $file.ll -o ${file}_out.ll

    echo "Generated ${file}_out.ll"

    # -----------------------------
    # AFTER CFG
    # -----------------------------
    rm -f .*.dot

    opt -passes=dot-cfg ${file}_out.ll -disable-output

    for dotfile in .*.dot
    do
        dot -Tpng "$dotfile" -o "${file}_after.png"
        break
    done

    echo "Generated ${file}_after.png"

done

echo ""
echo "===== ALL TESTS COMPLETED ====="
