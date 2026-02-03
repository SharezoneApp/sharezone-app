# Copyright (c) 2026 Sharezone UG (haftungsbeschränkt)
# Licensed under the EUPL-1.2-or-later.
#
# You may obtain a copy of the Licence at:
# https://joinup.ec.europa.eu/software/page/eupl
#
# SPDX-License-Identifier: EUPL-1.2

# A script to setup the [Jules](https://jules.google) environment:
# https://jules.google/docs/environment/

# Install Flutter & Dart
curl -fsSL https://fvm.app/install.sh | bash
echo 'export PATH="/home/jules/fvm/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
fvm install

# Install absort
go install github.com/leancodepl/arbsort@v0.1.0

# Install addlicense
go install github.com/google/addlicense@v1.1.1

# Install Prettier
npm install --global prettier@3.0.1

# PATH configurations
echo 'export PATH="/app/.fvm/flutter_sdk/bin:$PATH"' >> ~/.bash_profile # Flutter
echo 'export PATH="/app/.fvm/flutter_sdk/bin/cache/dart-sdk/bin:$PATH"' >> ~/.bash_profile # Dart
echo 'export PATH="$PATH:$HOME/go/bin"' >> ~/.bash_profile # Go
source ~/.bash_profile

# Install Sharezone Repo CLI
flutter pub global activate --source path "/app/tools/sz_repo_cli/"
echo 'export PATH="/app/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile

# Install Dart/Flutter dependencies
flutter pub get

# Generate localization files because "flutter pub get" removes the license
# header from generated files. We don't want uncommitted changes at the
# beginning of the session.
sz l10n generate