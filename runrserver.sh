#!/bin/bash
echo "Starting Rserve"
export R_HOME=/usr/lib/R

# Run Rserve in background
R CMD Rserve --no-save

# Process watcher
while true; do
  PID=`ps -ef | grep RsrvSRV | grep -v grep | awk '{print $2}'`
  if [ -z "$PID" ]; then
    exit 1
  fi
  sleep 1
done
