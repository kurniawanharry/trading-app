# matcha ID

A new Flutter application.

# Easy Localization:

1. flutter pub run easy_localization:generate --source-dir ./assets/translations
2. flutter pub run easy_localization:generate --source-dir ./assets/translations -f keys -o locale_keys.g.dart

# Build App

- [Android]:

  - [Build] :
    - [App Bundle]:
      - [PRD] : flutter build appbundle -t lib/launcher/main_prd.dart --flavor=prd
      - [DEV] : flutter build appbundle -t lib/launcher/main_dev.dart --flavor=stg
      - [DEV] : flutter build appbundle -t lib/launcher/main_stg.dart --flavor=dev
    - [Apk] :
      - [PRD] : flutter build apk -t lib/launcher/main_prd.dart --flavor=prod
      - [PRD] : flutter build apk -t lib/launcher/main_stg.dart --flavor=stg
      - [DEV] : flutter build apk -t lib/launcher/main_dev.dart --flavor=dev
  - [Run] :
    - [PRD] : flutter run -t lib/launcher/main_prd.dart --flavor=prd
    - [PRD-RELEASE] : flutter run -t lib/launcher/main_dev.dart --flavor=dev --release
    - [DEV] : flutter run -t lib/launcher/main_dev.dart --flavor=dev
    - [STG] : flutter run -t lib/launcher/main_dev.dart --flavor=stg
  - [Fastlane]:
    - [Firebase] :
      - [PRD] fastlane firebaseDistributePRD
      - [DEV] fastlane firebaseDistributeDEV

- [iOS]:
  - [Run] :
    - [PRD] flutter run ios -t lib/launcher/prod.dart --release --flavor prod
    - [DEV] flutter run ios -t lib/launcher/dev.dart --debug --flavor dev
  - [Build] :
    - [PRD] flutter build ios -t lib/launcher/prod.dart --release --no-codesign --flavor production
    - [DEV] flutter build ios -t lib/launcher/dev.dart --profile --no-codesign --flavor development
  - [Fastlane]:
    - [Firebase] :
      - [PRD] fastlane firebaseDistributePRD
      - [DEV] fastlane firebaseDistributeDEV
    - [APPSTORE] :
      - [RELEASE] cd
      - [BETA] fastlane beta
# package-based-modular-architecture
