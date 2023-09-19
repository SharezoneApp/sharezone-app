#!/bin/bash
# Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
# Licensed under the EUPL-1.2-or-later.
#
# You may obtain a copy of the Licence at:
# https://joinup.ec.europa.eu/software/page/eupl
#
# SPDX-License-Identifier: EUPL-1.2

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
get_cmd="$script_dir/source_of_truth/get_sot_cmd.sh"

check_format_action_files=$($get_cmd check_format_action_files)
eval $"($check_format_action_files)"
