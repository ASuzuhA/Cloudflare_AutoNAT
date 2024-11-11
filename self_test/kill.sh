#!/bin/bash

pkill socat

if [ $? -eq 0 ]; then
    echo "All socat processes have been terminated."
else
    echo "No socat processes were found or could not be terminated."
fi