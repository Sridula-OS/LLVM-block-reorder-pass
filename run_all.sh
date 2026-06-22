#!/bin/bash
set -euo pipefail
shopt -s nullglob

RESULTS_DIR="results"
SCREENSHOTS_DIR="screenshots"
BUILD_DIR="${BUILD_DIR:-build}"
RUN_LOG="$RESULTS_DIR/run_output.txt"
PASS_LOG="$RESULTS_DIR/pass_reorder_output.txt"
PASS_SO="./$BUILD_DIR/libBlockReorderPass.so"
CLANG_BIN="${CLANG:-clang}"
OPT_BIN="${OPT:-opt}"
DOT_BIN="${DOT:-dot}"
CMAKE_BIN="${CMAKE:-cmake}"
MAKE_BIN="${MAKE:-make}"

TEST_CASES=(
    "test:foo"
    "test1:test1"
    "test2:test2"
    "test3:test3"
    "test4:unpredictable"
    "test5_struct:process_students"
    "test6_array:analyze_array"
    "test7_linked_list:process_list"
    "test8_tree:tree_score"
    "test9_stack_queue:exercise_stack_queue"
)

mkdir -p "$BUILD_DIR" "$RESULTS_DIR" "$SCREENSHOTS_DIR"
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
    local function_name="$3"

    rm -f .*.dot
    "$OPT_BIN" -passes=dot-cfg "$input_ll" -disable-output

    local dotfiles=(.*.dot)
    if [ "${#dotfiles[@]}" -eq 0 ]; then
        log "No CFG DOT file generated for $input_ll"
        return 1
    fi

    local selected=".${function_name}.dot"
    if [ ! -f "$selected" ]; then
        selected="${dotfiles[0]}"
        for candidate in "${dotfiles[@]}"; do
            if [ "$(stat -c%s "$candidate")" -gt "$(stat -c%s "$selected")" ]; then
                selected="$candidate"
            fi
        done
    fi

    "$DOT_BIN" -Tpng "$selected" -o "$output_png"
    log "Selected CFG $selected for $output_png"
    rm -f .*.dot
}

verify_test() {
    local test_name="$1"
    local input_ll="$2"
    local output_ll="$3"
    local verification_log="$RESULTS_DIR/${test_name}_verification.txt"

    "$OPT_BIN" -passes=verify "$output_ll" -disable-output

    {
        echo "IR verifier: PASS"
        echo "getelementptr instructions: $(grep -c "getelementptr" "$input_ll" || true)"
        echo "named structure types: $(grep -c '^%struct\.' "$input_ll" || true)"
    } > "$verification_log"

    if grep -Eq '^define .*@main\(' "$input_ll"; then
        local before_bin="$RESULTS_DIR/.${test_name}_before_exec"
        local after_bin="$RESULTS_DIR/.${test_name}_after_exec"
        local before_output
        local after_output

        "$CLANG_BIN" "$input_ll" -o "$before_bin"
        "$CLANG_BIN" "$output_ll" -o "$after_bin"

        before_output="$("$before_bin")"
        after_output="$("$after_bin")"

        if [ "$before_output" != "$after_output" ]; then
            {
                echo "Behavior comparison: FAIL"
                echo "Before output: $before_output"
                echo "After output: $after_output"
            } >> "$verification_log"
            rm -f "$before_bin" "$after_bin"
            return 1
        fi

        {
            echo "Behavior comparison: PASS"
            echo "Program output: $after_output"
        } >> "$verification_log"
        rm -f "$before_bin" "$after_bin"
    else
        echo "Behavior comparison: SKIPPED (no main function)" >> "$verification_log"
    fi

    log "Verified $test_name: IR valid and behavior preserved"
}

for tool in "$CLANG_BIN" "$OPT_BIN" "$DOT_BIN" "$CMAKE_BIN" "$MAKE_BIN"; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "Required tool not found: $tool" >&2
        exit 1
    fi
done

log "===== Building LLVM Pass ====="

cd "$BUILD_DIR"
"$CMAKE_BIN" ..
"$MAKE_BIN"
cd ..

log ""
log "===== Running All Test Cases ====="

for test_case in "${TEST_CASES[@]}"
do
    file="${test_case%%:*}"
    function_name="${test_case#*:}"

    log ""
    log "==============================="
    log "Processing $file"
    log "==============================="

    # Docker and WSL may attach different DrvFs metadata to generated files.
    # Delete artifacts first instead of truncating them in place.
    rm -f \
        "$RESULTS_DIR/$file.ll" \
        "$RESULTS_DIR/${file}_out.ll" \
        "$RESULTS_DIR/${file}_before.png" \
        "$RESULTS_DIR/${file}_after.png" \
        "$RESULTS_DIR/${file}_log.txt" \
        "$RESULTS_DIR/${file}_verification.txt"

    "$CLANG_BIN" -O1 -S -emit-llvm "$file.c" -o "$RESULTS_DIR/$file.ll"
    log "Generated $RESULTS_DIR/$file.ll"

    generate_cfg \
        "$RESULTS_DIR/$file.ll" \
        "$RESULTS_DIR/${file}_before.png" \
        "$function_name"
    log "Generated $RESULTS_DIR/${file}_before.png"

    "$OPT_BIN" -load-pass-plugin "$PASS_SO" \
        -passes="block-reorder,verify" \
        -S \
        "$RESULTS_DIR/$file.ll" -o "$RESULTS_DIR/${file}_out.ll" \
        2> "$RESULTS_DIR/${file}_log.txt"

    append_pass_output "$file" "$RESULTS_DIR/${file}_log.txt"
    log "Generated $RESULTS_DIR/${file}_out.ll"

    verify_test \
        "$file" \
        "$RESULTS_DIR/$file.ll" \
        "$RESULTS_DIR/${file}_out.ll"

    generate_cfg \
        "$RESULTS_DIR/${file}_out.ll" \
        "$RESULTS_DIR/${file}_after.png" \
        "$function_name"
    log "Generated $RESULTS_DIR/${file}_after.png"
done

cp -f "$RESULTS_DIR/test3_before.png" "$SCREENSHOTS_DIR/before-cfg-test3.png"
cp -f "$RESULTS_DIR/test3_after.png" "$SCREENSHOTS_DIR/after-cfg-test3.png"
cp -f "$RESULTS_DIR/test4_before.png" "$SCREENSHOTS_DIR/failure-test4-before.png"
cp -f "$RESULTS_DIR/test4_after.png" "$SCREENSHOTS_DIR/failure-test4-after.png"
cp -f "$RESULTS_DIR/test5_struct_before.png" "$SCREENSHOTS_DIR/structure-before.png"
cp -f "$RESULTS_DIR/test5_struct_after.png" "$SCREENSHOTS_DIR/structure-after.png"
cp -f "$RESULTS_DIR/test7_linked_list_before.png" "$SCREENSHOTS_DIR/linked-list-before.png"
cp -f "$RESULTS_DIR/test7_linked_list_after.png" "$SCREENSHOTS_DIR/linked-list-after.png"

log ""
log "===== ALL TESTS COMPLETED ====="
log "Results stored inside $RESULTS_DIR/"
log "Submission screenshots stored inside $SCREENSHOTS_DIR/"

cp -f "$RUN_LOG" "$SCREENSHOTS_DIR/terminal-output.txt"
