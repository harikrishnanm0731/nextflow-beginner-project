#!/bin/bash -ue
echo "Hello from sample: sampleA" > sampleA.result.txt
echo "Line count: $(cat sampleA.count.txt)" >> sampleA.result.txt
