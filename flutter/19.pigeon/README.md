# A Pigeon example

**Warning: Pigeon is prerelease at the time the example was ran, it may not work due to break changes**

## How was this example setup?

This example was setup following the guidance from Pigeon package, you can [check it out here][1]. Below are commands to initialize the code boilerplate.

1. Create an app, named `pigeon_hello`

```bash
flutter create pigeon_hello
```

1. Create an plugin, named `pigeon_hello_plugin`

```bash
flutter create --template=plugin pigeon_hello_plugin
```

3. Create platform interface, named `pigeon_hello_platform_interface`. This interface allows platform-specific implementations of the `pigeon_hello_plugin`, as well as the plugin itself, to ensure they are supporting the same interface. See more about platform interface at [Federated plugin implementations][2]

```bash
flutter create --template=package pigeon_hello_platform_interface
```

## How to re-generate Pigeon messages?

Cd to `pigeon_hello_plugin`, run follow command:

```bash
flutter pub run pigeon --input pigeons/messages.dart
```

[1]: https://github.com/flutter/packages/tree/master/packages/pigeon
[2]: https://docs.google.com/document/u/1/d/1LD7QjmzJZLCopUrFAAE98wOUQpjmguyGTN2wd_89Srs/edit