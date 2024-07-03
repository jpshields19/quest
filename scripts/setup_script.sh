#!/bin/bash
while IFS= read -r line; do
    if [[ $line && ! $line =~ ^# ]]; then
        export "$line"
    fi
done < .env