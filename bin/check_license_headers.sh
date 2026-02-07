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

check_license_headers=$($get_cmd check_license_headers)
# We use "git ls-files" and "xargs" to speed up the command, see
# https://github.com/google/addlicense/issues/32#issuecomment-3855110707.
eval $"(git ls-files -z | xargs -0 -n 200 $check_license_headers)"
