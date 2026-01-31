#!/bin/bash
# Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
# Licensed under the EUPL-1.2-or-later.
#
# You may obtain a copy of the Licence at:
# https://joinup.ec.europa.eu/software/page/eupl
#
# SPDX-License-Identifier: EUPL-1.2

# A script to setup the Codex Cloud Environment
# (https://developers.openai.com/codex/cloud/environments).

set -e # Exit on error

# Install Flutter & Dart
curl -fsSL https://fvm.app/install.sh | bash
echo 'export PATH="/root/fvm/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH="/workspace/sharezone-app/.fvm/flutter_sdk/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH="/workspace/sharezone-app/.fvm/flutter_sdk/bin/cache/dart-sdk/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
fvm install

# Install absort
go install github.com/leancodepl/arbsort@v0.1.0

# Install addlicense
go install github.com/google/addlicense@v1.1.1

# Install Sharezone Repo CLI
flutter pub global activate --source path "/workspace/sharezone-app/tools/sz_repo_cli/"
echo 'export PATH="/workspace/sharezone-app/bin:$PATH"' >> ~/.bash_profile
