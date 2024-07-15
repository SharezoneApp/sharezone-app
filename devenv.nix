# Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
# Licensed under the EUPL-1.2-or-later.
#
# You may obtain a copy of the Licence at:
# https://joinup.ec.europa.eu/software/page/eupl
#
# SPDX-License-Identifier: EUPL-1.2

{ pkgs, inputs, lib, ... }:

let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.system; };
  flutter = pkgs-unstable.flutter.overrideAttrs
    {
      src = pkgs-unstable.fetchFromGitHub
        {
          owner = "flutter";
          repo = "flutter";
          rev = "3.22.2";
          sha256 = "7ndnIw72YxNB+VeeejEeRD+xxuLXOcWo322s5CMWzBM=";
        };
    };
  androidenv = android-pkgs.androidenv.override {
    # Seems to only work when androidenv.buildApp is used 
    # afterwards (we don't).
    # We accept the licenses below via extraLicenses.
    licenseAccepted = true;
  };
  android-comp = androidenv.composeAndroidPackages {
    buildToolsVersions = [ "34.0.0" ];
    # We probably don't need all of those?
    # These were copied from another devenv.nix from GitHub.
    platformVersions = [ "29" "30" "31" "33" "34" ];

    # The `licenseAccepted = true;` seems to only work when androidenv.buildApp
    # is used. Since Flutter doesn't use that it doesn't work.
    # Therefore we can manually accept the different licenses here.
    # Copied from: https://github.com/NixOS/nixpkgs/issues/267263#issuecomment-1833769682
    extraLicenses = [
      "android-googletv-license"
      "android-sdk-arm-dbt-license"
      "android-sdk-license"
      "android-sdk-preview-license"
      "google-gdk-license"
      "intel-android-extra-license"
      "intel-android-sysimage-license"
      "mips-android-sysimage-license"
    ];
  };
  android-pkgs = if pkgs.stdenv.system == "aarch64-darwin" then pkgs.pkgsx86_64Darwin else pkgs;
  android-sdk = android-comp.androidsdk;
  android-sdk-root = "${android-sdk}/libexec/android-sdk";
in
{

  env = {
    ANDROID_HOME = "${android-sdk-root}";
    ANDROID_SDK_ROOT = "${android-sdk-root}";
    FLUTTER_ROOT = "${flutter}";
    CHROME_EXECUTABLE = "${pkgs.google-chrome}/bin/google-chrome-stable";
  };

  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.nixpkgs-fmt

    # Running `fvm flutter` -> 'Missing "unzip" tool. Unable to extract Dart SDK.'
    pkgs.unzip
    android-sdk
    flutter

    # For Flutter Web development
    pkgs.google-chrome

    # Used by sharezone developers / sz cli
    pkgs.addlicense
    pkgs.nodePackages.prettier
    pkgs.nodePackages.firebase-tools
  ];

  enterShell = ''
    # Make pub cache work so that we can execute
    # e.g. `dart pub global activate fvm`
    #export PATH="$PATH":"$HOME/.pub-cache/bin"

    # Make sz cli work
    export PATH="$PATH":"$DEVENV_ROOT/bin"

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

  languages = {
    # Needed for Android SDK
    java = {
      enable = true;
      jdk.package = pkgs.jdk17;
    };
  };

  # See full reference at https://devenv.sh/reference/options/
}
