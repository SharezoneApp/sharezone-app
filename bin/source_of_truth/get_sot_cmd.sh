#!/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
commands_file="$script_dir/commands_source_of_truth.yaml"

# Will search for String given by argument ($1) and return the rest of the line in which the string was found.
# For example:
# .yaml contains "foo: echo abc"
# Then running this file with $1 == "foo"
# will echo "echo abc".
echo $(sed -n -e 's/^.*'$1': //p' $commands_file)