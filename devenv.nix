{ pkgs, ... }:

let
  androidenv = android-pkgs.androidenv.override {
    licenseAccepted = true;
  };
  android-comp = androidenv.composeAndroidPackages {
    buildToolsVersions = [ "34.0.0" ];
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
    FLUTTER_ROOT = "${pkgs.flutter}";
    CHROME_EXECUTABLE = "${pkgs.google-chrome}/bin/google-chrome-stable";
  };

  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.nixpkgs-fmt
    pkgs.addlicense
    pkgs.nodePackages.prettier
    # Running `fvm flutter` -> 'Missing "unzip" tool. Unable to extract Dart SDK.'
    pkgs.unzip
    android-sdk
    pkgs.nodePackages.firebase-tools
    pkgs.google-chrome
  ];

  enterShell = ''
    # Make pub work
    export PATH="$PATH":"$HOME/.pub-cache/bin"

    # Make sz cli work
    export PATH="$PATH":"$DEVENV_ROOT/bin"

    fvm flutter config --android-sdk ${android-sdk-root}

    # When running e.g. `sz pub get -c 0` the analytics
    # will cause the task to fail (maybe because so many signals
    # are sent in a short time). So we just disable analytics
    # so that they can not fail because of this reason.
    fvm dart --disable-analytics
    fvm flutter --disable-analytics

    # So that we can use the sz cli instantly.
    # Otherwise if this is a first install we would first
    # need to manually get the packages there so that
    # we can run `sz pub get` afterwards for the other packages.
    if [ ! -d $DEVENV_ROOT/tools/sz_repo_cli/.dart_tool ]; then
      fvm dart pub get --directory ./tools/sz_repo_cli
    fi

    if ! command -v fvm &> /dev/null
    then
        echo "fvm could not be found. Installing FVM."
        dart pub global activate fvm
        # fvm install will fail getting dependencies if we dont
        # cd to app. Using && will only change it for the fvm
        # install command
        cd app && fvm install
        
    fi
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep "2.42.0"
  '';

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  languages = {
    # Needed for Android SDK
    java = {
      enable = true;
      jdk.package = pkgs.jdk17;
    };

    dart.enable = true;
  };

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # https://devenv.sh/processes/
  # processes.ping.exec = "ping example.com";

  # See full reference at https://devenv.sh/reference/options/
}
