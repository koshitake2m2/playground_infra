#!/bin/sh

for dir in `ls -d */`; do
    path="${dir}.terraform";
    echo $path;
    rm -rf $path;
done

