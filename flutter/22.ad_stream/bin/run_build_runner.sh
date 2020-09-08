#!/usr/bin/env bash

BIN_DIR=$(dirname $0)
APP_DIR="$(cd $BIN_DIR/../packages/ad_stream && pwd)"

# config
DI_FILE_PATH="$APP_DIR/lib/src/modules/di/di.inject.dart"
DI_BK_FILE_PATH="$APP_DIR/lib/src/modules/di/di.inject.dart.bk"

# run inject_generator
cd $APP_DIR

flutter pub run build_runner build --delete-conflicting-outputs

# clean empty files and keep di.inject.dart
cp $DI_FILE_PATH $DI_BK_FILE_PATH
flutter pub run build_runner clean
mv $DI_BK_FILE_PATH $DI_FILE_PATH

cd - > /dev/null
