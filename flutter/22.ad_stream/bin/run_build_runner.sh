#!/usr/bin/env bash

BIN_DIR=$(dirname $0)
APP_DIR="$BIN_DIR/../packages/ad_stream"

# config
FLUTTER_HOME='~/opt/flutter'
DI_FILE_PATH="$APP_DIR/lib/src/modules/di/di.inject.dart"
DI_BK_FILE_PATH="$APP_DIR/lib/src/modules/di/di.inject.dart.bk"

cd $APP_DIR

# run inject_generator
eval "$FLUTTER_HOME/bin/flutter pub run build_runner build --delete-conflicting-outputs"

# clean empty files and keep di.inject.dart
cp $DI_FILE_PATH $DI_BK_FILE_PATH
eval "$FLUTTER_HOME/bin/flutter pub run build_runner clean"
mv $DI_BK_FILE_PATH $DI_FILE_PATH
