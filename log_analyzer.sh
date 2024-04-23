#!/bin/bash

# Function to monitor log file
monitor_log_file() {
    log_file="$1"
    if [ ! -f "$log_file" ]; then
        echo "Error: Log file not found."
        exit 1
    fi
    echo "Monitoring log file: $log_file"
    tail -n 0 -f "$log_file" &
    tail_pid=$!
    trap "kill $tail_pid; echo 'Monitoring stopped.'; exit 0" SIGINT
    wait $tail_pid
}

# Function to perform basic log analysis
analyze_log() {
    log_file="$1"
    if [ ! -f "$log_file" ]; then
        echo "Error: Log file not found."
        exit 1
    fi
    echo "Analyzing log file: $log_file"
    error_pattern="ERROR:.*"  # Example pattern for error messages
    errors=$(grep -E "$error_pattern" "$log_file")
    if [ -n "$errors" ]; then
        echo "Top Error Messages:"
        echo "$errors"
    else
        echo "No errors found in the log file."
    fi
}

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 [monitor/analyze] [log_file_path]"
    exit 1
fi

action="$1"
log_file="$2"

if [ "$action" == "monitor" ]; then
    monitor_log_file "$log_file"
elif [ "$action" == "analyze" ]; then
    analyze_log "$log_file"
else
    echo "Invalid action. Use 'monitor' or 'analyze'."
    exit 1
fi
