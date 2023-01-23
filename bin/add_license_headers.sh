#!/bin/bash

root_dir=$(git rev-parse --show-toplevel)

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
get_cmd="$script_dir/source_of_truth/get_sot_cmd.sh"

check_license_headers=$($get_cmd add_license_headers)
eval $"($check_license_headers $root_dir)"