#!/bin/bash
# Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
# Licensed under the EUPL-1.2-or-later.
#
# You may obtain a copy of the Licence at:
# https://joinup.ec.europa.eu/software/page/eupl
#
# SPDX-License-Identifier: EUPL-1.2

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
commands_file="$script_dir/commands_source_of_truth.yaml"

# Will search for String given by argument ($1) and return the rest of the line in which the string was found.
# For example:
# .yaml contains "foo: echo abc"
# Then running this file with $1 == "foo"
# will echo "echo abc".
echo $(sed -n -e 's/^.*'$1': //p' $commands_file)
