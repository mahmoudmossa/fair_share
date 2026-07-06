#!/bin/bash
# Script to generate Firebase configuration files for different environments/flavors
# Feel free to reuse and adapt this script for your own projects

if [[ $# -eq 0 ]]; then
  echo "Error: No environment specified. Use 'dev', 'cons', or 'prod'."
  exit 1
fi

case $1 in
  dev)
    flutterfire config \
      --project=fairshare-ffea8 \
      --out=lib/firebase_options_dev.dart \
      --ios-bundle-id=com.fair_share.dev \
      --ios-out=ios/flavors/dev/GoogleService-Info.plist \
      --android-package-name=com.fair_share.dev \
      --android-out=android/app/src/dev/google-services.json
    ;;
  cons)
    flutterfire config \
      --project=fairshare-ffea8 \
      --out=lib/firebase_options_cons.dart \
      --ios-bundle-id=com.fair_share.cons \
      --ios-out=ios/flavors/cons/GoogleService-Info.plist \
      --android-package-name=com.fair_share.cons \
      --android-out=android/app/src/cons/google-services.json
    ;;
  prod)
    flutterfire config \
      --project=fairshare-ffea8 \
      --out=lib/firebase_options_prod.dart \
      --ios-bundle-id=com.fair_share \
      --ios-out=ios/flavors/prod/GoogleService-Info.plist \
      --android-package-name=com.fair_share \
      --android-out=android/app/src/prod/google-services.json
    ;;
  *)
    echo "Error: Invalid environment specified. Use 'dev', 'cons', or 'prod'."
    exit 1
    ;;
esac