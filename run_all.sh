#!/bin/bash
set -euo pipefail
shopt -s nullglob

RESULTS_DIR="results"
SCREENSHOTS_DIR="screenshots"
RUN_LOG="$RESULTS_DIR/run_output.txt"
PASS_LOG="$RESULTS_DIR/pass_reorder_output.txt"
PASS_SO="./build/libBlockReorderPass.so"

mkdir -p build "$RESULTS_DIR" "$SCREENSHOTS_DIR"
: > "$RUN_LOG"
: > "$PASS_LOG"

log() {
    echo "$@" | tee -a "$RUN_LOG"
}

append_pass_output() {
    local test_name="$1"
    local test_log="$2"

    {
        echo ""
        echo "----- Detailed block reorder output for $test_name -----"
        cat "$test_log"
    } | tee -a "$RUN_LOG" "$PASS_LOG"
}

generate_cfg() {
    local input_ll="$1"
    local output_png="$2"

    rm -f .*.dot
    opt -passes=dot-cfg "$input_ll" -disable-output

    local dotfiles=(.*.dot)
    if [ "${#dotfiles[@]}" -eq 0 ]; then
        log "No CFG DOT file generated for $input_ll"
        return 1
    fi

    dot -Tpng "${dotfiles[0]}" -o "$output_png"
    rm -f .*.dot
}

log "===== Building LLVM Pass ====="

cd build
cmake ..
make
cd ..

log ""
log "===== Running All Test Cases ====="

for file in test test1 test2 test3 test4
do
    log ""
    log "==============================="
    log "Processing $file"
    log "==============================="

    clang -O1 -S -emit-llvm "$file.c" -o "$RESULTS_DIR/$file.ll"
    log "Generated $RESULTS_DIR/$file.ll"

    generate_cfg "$RESULTS_DIR/$file.ll" "$RESULTS_DIR/${file}_before.png"
    log "Generated $RESULTS_DIR/${file}_before.png"

    opt -load-pass-plugin "$PASS_SO" \
        -passes="block-reorder" \
        "$RESULTS_DIR/$file.ll" -o "$RESULTS_DIR/${file}_out.ll" \
        2> "$RESULTS_DIR/${file}_log.txt"

    append_pass_output "$file" "$RESULTS_DIR/${file}_log.txt"
    log "Generated $RESULTS_DIR/${file}_out.ll"

    generate_cfg "$RESULTS_DIR/${file}_out.ll" "$RESULTS_DIR/${file}_after.png"
    log "Generated $RESULTS_DIR/${file}_after.png"
done

cp -f "$RESULTS_DIR/test3_before.png" "$SCREENSHOTS_DIR/before-cfg-test3.png"
cp -f "$RESULTS_DIR/test3_after.png" "$SCREENSHOTS_DIR/after-cfg-test3.png"
cp -f "$RESULTS_DIR/test4_before.png" "$SCREENSHOTS_DIR/failure-test4-before.png"
cp -f "$RESULTS_DIR/test4_after.png" "$SCREENSHOTS_DIR/failure-test4-after.png"

log ""
log "===== ALL TESTS COMPLETED ====="
log "Results stored inside $RESULTS_DIR/"
log "Submission screenshots stored inside $SCREENSHOTS_DIR/"

cp -f "$RUN_LOG" "$SCREENSHOTS_DIR/terminal-output.txt"
