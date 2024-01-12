#!/bin/bash

# Command to execute your job
JOB_COMMAND="sbatch mmlu-full.sh"

# Function to get the latest log file name
get_latest_log_file() {
    ls -lrt gpuTest_*err | tail -n 1 | awk '{print $NF}'
}

# Function to get the corresponding .out file for a given .err file
get_corresponding_out_file() {
    echo "$1" | sed 's/\.err$/.out/'
}

# Function to check the last five lines of the latest log file for the error
check_last_lines_for_error() {
    last_lines=$(tail -n 5 "$1")
    if echo "$last_lines" | grep -q "RuntimeError: CUDA"; then
        return 0
    else
        echo "Execution Completed Successfully."
        return 1
    fi
}

# Main loop
while true; do
    # Execute your job
    $JOB_COMMAND

    # Wait for a bit to ensure the log file is updated
    sleep 20  # Adjust this duration as needed

    # Get the latest log file
    LOG_FILE=$(get_latest_log_file)

    # Check the last five lines of the latest log file for the error
    if check_last_lines_for_error "$LOG_FILE"; then
        echo "Detected 'CUDA error' in $LOG_FILE. Deleting log and output files, and waiting 30 seconds before re-execution."

        # Delete the .err log file
        rm -f "$LOG_FILE"

        # Get and delete the corresponding .out file
        OUT_FILE=$(get_corresponding_out_file "$LOG_FILE")
        rm -f "$OUT_FILE"

        sleep 15
    else
        break
    fi
done