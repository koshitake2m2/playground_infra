#!/bin/sh

removes=""

# TODO: Use `find` command.
for dir in `ls -d */`; do
    target="${dir}.terraform"
    removes="$removes\n$target"
done



# Removes
echo $removes

echo "Exit... Unssuccessful..."
exit 1

for r in $removes; do
    rm -rf $r;
done
