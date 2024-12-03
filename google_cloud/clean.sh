#!/bin/sh

removes="./gar/app/node_modules"

for target in `find . -name "*.terraform"`; do
    removes="$removes:$target"
done

for r in `echo $removes | tr ":" "\n"`; do
    echo "Removing $r"
    # rm -rf $r; # TODO: Uncomment this line
done

echo "Exit... Unssuccessful... Please fix me..."
exit 1
