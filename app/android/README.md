# Android

## How to upgrade Gradle Wrapper

```sh
./gradlew wrapper --gradle-version YOUR_VERSION --distribution-type bin
```

## How to upgrade Kotlin

1. Go to `app/android/settings.gradle`
2. Change the version of `org.jetbrains.kotlin.android`.
3. Ensure your Gradle version is compatible with the new Kotlin plugin version. Check the compatibility in the [Kotlin release notes](https://kotlinlang.org/docs/releases.html#release-details).

## How to upgrade Android Gradle plugin

1. Go to `app/android/settings.gradle`
2. Change the version of `com.android.application`
