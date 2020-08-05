# Vendor

Contains packages from third-party provider.

## Inject and Inject Generator

These two packages are for experiencing Compile-time dependency injection. 

Noice that due to the pending of development of this project https://github.com/google/inject.dart, the code generator may not work when depencency packages are auto resolve to higher version.

### What is the command to run the code generator?

cd to `ad_stream` folder, run

	flutter pub run build_runner build


### What is the output of the code generator?

a new file is added

	app_stream/lib/src/modules/di/di.inject.dart
