# Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
# Licensed under the EUPL-1.2-or-later.
#
# You may obtain a copy of the Licence at:
# https://joinup.ec.europa.eu/software/page/eupl
#
# SPDX-License-Identifier: EUPL-1.2

{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  # Used so that we can select a specific version of Flutter
  pkgs-flutter = import inputs.nixpkgs-flutter { system = pkgs.stdenv.system; };
in
{

  env = {
    CHROME_EXECUTABLE = "${pkgs.chromium}/bin/chromium";
  };

  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.nixpkgs-fmt

    # Running `fvm flutter` -> 'Missing "unzip" tool. Unable to extract Dart SDK.'
    pkgs.unzip

    # For Flutter Web development
    # pkgs.google-chrome lead to long local builds that don't happen with pkgs.chromium.
    pkgs.chromium

    # Used by sharezone developers / sz cli
    pkgs.addlicense
    pkgs.nodePackages.prettier
    pkgs.nodePackages.firebase-tools
  ];

  enterShell = ''
    export ANDROID_HOME=$(which android | sed -E 's/(.*libexec\/android-sdk).*/\1/')
    export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH

    # Make sz cli work
    export PATH="$PATH":"$DEVENV_ROOT/bin"

    flutter config --android-sdk $ANDROID_HOME

    # When running e.g. `sz pub get -c 0` the analytics
    # will cause the task to fail (maybe because so many signals
    # are sent in a short time). So we just disable analytics
    # so that they can not fail because of this reason.
    dart --disable-analytics &
    flutter --disable-analytics

    # We get the package in the sz cli folder so that one can
    # start running e.g. `sz pub get` right away. Without this 
    # one would first have to run pub get in the sz cli folder 
    # manually.
    dart pub get --directory ./tools/sz_repo_cli
  '';

  # Create an Android emulator named "android-simple"
  scripts.create-emulator.exec = ''
    avdmanager create avd -n android-simple -k "system-images;android-34;google_apis_playstore;x86_64" --device "pixel_6_pro"
  '';

  android = {
    enable = true;
    # Otherwise we get:
    #    FAILURE: Build failed with an exception.
    #    * Where:
    #    Build file '/home/jsan/development/projects/sharezone-app/app/android/build.gradle' line: 13
    #
    #    * What went wrong:
    #    A problem occurred evaluating root project 'android'.
    #    > A problem occurred configuring project ':app'.
    #       > com.android.builder.sdk.InstallFailedException: Failed to install the following SDK components:
    #             ndk;26.3.11579264 NDK (Side by side) 26.3.11579264
    #         The SDK directory is not writable (/nix/store/iqrggkmmq55v3db7ns5rmr62x8bq0ymz-androidsdk/libexec/android-sdk)
    ndk = {
      enable = true;
      version = [ "27.0.12077973" ];
    };
    # > Failed to install the following SDK components:
    #  build-tools;34.0.0 Android SDK Build-Tools 34
    buildTools.version = [ "34.0.0" ];
    # > Failed to install the following SDK components:
    #   platforms;android-31 Android SDK Platform 31 (etc. for 33, 34, 35)
    platforms.version = [
      "31"
      "33"
      "34"
      "35"
      "36"
    ];
    flutter = {
      enable = true;
      package = pkgs-flutter.flutter;
    };
  };

  # See full reference at https://devenv.sh/reference/options/
}
