#!/usr/bin/env bash

function run_test() {
  export RANDOM_STATE_WIDTH=$1
  export RANDOM_STATE_HEIGHT=$2
  mkdir -p log
  LOG_FILE=log/${RANDOM_STATE_WIDTH}x${RANDOM_STATE_HEIGHT}_$(date +"%y-%m-%d_%H%M%S").log
  echo "Running ${RANDOM_STATE_WIDTH}x${RANDOM_STATE_HEIGHT} test..."
  xcodebuild test \
    -project ./xcode/PuzzleProblem.xcodeproj \
    -scheme PuzzleProblemRandomSearchTests > $LOG_FILE
  echo "Done"
}

run_test $@
