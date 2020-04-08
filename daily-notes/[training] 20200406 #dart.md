[training] 20200406 #dart

Hi Trung,

I spent these days to get started with Dart/Flutter. I’m able to access basic toolchains such as Dart SDK, Flutter SDK, Android Studio, Xcode and VSCode.

I can run/debug a few sample Flutter applications, and I was very impressed by instant hot reload. It works seamlessly on both iOS and Android.  I really like it, thanks to [Dart Compilation AOT and JIT](https://kodytechnolab.com/why-flutter-uses-dart).

Then, I take a [Language Tour](https://dart.dev/guides/language/language-tour) today to dive deep into the Dart Language. Dart is an object-oriented language, most of its syntax and features are quite familiar to me. So I only take note on what I think it’s noticeable, if you see features that I need to pay more attention, please let me know.

Below is my status today.

**Dart important concepts**

* Every object is an instance of a class. Even numbers, functions, and null are objects.
* Dart is a strong type. Dart have type annotations (e.g: @immutable, @required). Dynamic is a special type represent for no type is expected.
* Dart supports top-level variables and top-level functions (such as main()).
* Dart doesn’t have scope modifier. Name variable starts with an underscore (_) to implicitly indicate privately to its library.

**Dart Keywords Highlight**

_abstract_

* Use abstract modifier to define an abstract class.
* Abstract class can’t be instantiated as usual.
* Abstract class can be instantiable by factory constructor. E.g:

```
abstract class DeviceDiscovery {
  factory DeviceDiscovery() {
    switch (deviceOperatingSystem) {
      case DeviceOperatingSystem.android:
        return AndroidDeviceDiscovery();
      case DeviceOperatingSystem.ios:
        return IosDeviceDiscovery();
      default:
        throw StateError(‘Unsupported device operating system’);
    }
  }

  //// …
}

class AndroidDeviceDiscovery implements DeviceDiscovery { … }
class IosDeviceDiscovery implements DeviceDiscovery { … }
```

_factory_

* Use factory keyword when implementing a constructor that doesn’t always create a new instance of its class. E.g:

```
class Logger {
  final String name;

  // _cache is library-private, thanks to
  // the _ in front of its name.
  static final Map<String, Logger> _cache =
      <String, Logger>{};
  factory Logger(String name) {
    return _cache.putIfAbsent(name, () => Logger._internal(name));
  }
  Logger._internal(this.name);
}
```

* Other interesting use-case of factory keyword is to implement the singleton pattern.

```
class DbClient {
  factory DbClient() {
    return _instance ??= DbClient._();
  }
  DbClient._();
  static DbClient _instance;
}
```

* Factory constructors have no access to this.

_get/set_

```
class Rectangle {
  num left, top, width, height;

  Rectangle(this.left, this.top, this.width, this.height);

  // Define two calculated properties: right and bottom.
  num get right => left + width;
  set right(num value) => left = value - width;
  num get bottom => top + height;
  set bottom(num value) => top = value - height;
}
```

_final_

* final means single-assignment. Once assigned a value, a final variable’s value cannot be changed.

_const_

* const declares variables that are compile-time constants.
* const variable is at class-level should be marked as static const.
* Use const to create constant values, as well as to declare a constructor that creates constant values.
* const means that the object’s entire deep state can be determined entirely at compile-time and that the object will be frozen and completely immutable.

_final vs const_

* const object is deeply, transitively immutable. A final field containing a collection, that collection can still be mutable. A const collection, everything in it must also be const, recursively.
* const value must be known at compile time. 1 + 2 is a valid const expression, but DateTime.now() is not.
* const object will be created and re-used no matter how many times the const expression(s) are evaluated. In Flutter, const Widget is used to minimize the impact of rebuilding a stateful widget, the engine cache the const Widget and re-using it.

_spread operator (…)_

```
var list = [1, 2, 3];
var list2 = [0, ...list];
assert(list2.length == 4);
```

_null-aware spread operator (…?)_

```
var list;
var list2 = [0, …?list];
assert(list2.length == 1);
```

_collection if_

```
var nav = [
  ‘Home’,
  ‘Plants’,
  if (promoActive) ‘Outlet’
];
```

_collection for_

```
var listOfInts = [1, 2, 3];
var listOfStrings = [
  ‘#0’,
  for (var i in listOfInts) ‘#$i’;
];
```

_set_

* A set in Dart is an unordered collection of unique items

```
var names = <String>{};
Set<String> names = {};
// var names = {}; // Creates a map, not a set.
```

**Implicit interfaces**

* Every class implicitly defines an interface containing all the instance members of the class and of any interfaces it implements.

**Compiling and Exciting Dart**

* Dart is excellent at compiling both AOT and JIT. Dart supports both types of compilation.
* During the development, with fast compiler, JIT compilation is performed.
* When the app is ready for deployment, it is compiled AOT.
* Dart accelerates better and rapid development cycles and quick and fast Execution and startup times.

**Built-in types**

* numbers
* strings
* booleans
* lists (also known as arrays)
* sets
* maps
* runes (for expressing Unicode characters in a string)
* symbols

_Strings_

* create a “raw” string by prefixing it with r. E.g
```
var s = r'In a raw string, not even \n gets special treatment.';
```

* Literal strings are compile-time constants, as long as any interpolated expression is a compile-time constant that evaluates to null or a numeric, string, or boolean value.

```
// These work in a const string.
const aConstNum = 0;
const aConstBool = true;
const aConstString = ‘a constant string’;

// These do NOT work in a const string.
var aNum = 0;
var aBool = true;
var aString = ‘a string’;
const aConstList = [1, 2, 3];

const validConstString = ‘$aConstNum $aConstBool $aConstString’;
// const invalidConstString = ‘$aNum $aBool $aString $aConstList’;
```

**Functions**

* Optional parameters can be either named or positional, but not both.
* use _{param1, param2, …}_ to specify named parameters

```
void enableFlags({bool bold, bool hidden}) {…}
```

* named parameters are optional, annotate them with @required to indicate that the parameter is mandatory.

```
const Scrollbar({Key key, @required Widget child})
```

* Wrapping a set of function parameters in [] marks them as optional positional parameters.

```
String say(String from, String msg, [String device]) {…}
```

* Functions as first-class objects
* Like JavaScript, Dart has _lexical scope_, _lexical closures_
* All functions return a value. If omit, it returns a null value.

**Operators**

* Dart has the similar operator list  to JavaScript. There are few noticeable operators are:
- Type cast operator: `as`. 
- Type test operators: is, `is!`  <—— it’s `is!`, not `!is`
- Divide, returning an integer result: `~/`. E.g: 5 ~/ 2 = 2
- Conditional expressions: `expr1 ?? expr2`. If _expr1_ is non-null, returns its value; otherwise, evaluates and returns the value of _expr2_.
* Cascade notation `..`
* Cascades `..` can make a sequence of operations on the same object.
* E.g:

```
querySelector(‘#confirm’) // Get an object.
  ..text = ‘Confirm’ // Use its members.
  ..classes.add(‘important’)
  ..onClick.listen((e) => window.alert(‘Confirmed!’));
```

**Classes**

* Dart is an object-oriented language with classes and mixin-based inheritance.

*Class members*

* Every object is an instance of a class, and all classes descend from  [Object.](https://api.dart.dev/stable/dart-core/Object-class.html). There is no primitive types, numbers, function, even null are objects.
* Use runtimeType property to get object’s type at runtime
* All uninitialized instance variables have the value null

** Constructor**

* To create a compile-time constant using a constant constructor

```
var p = const ImmutablePoint(2, 2);
```

* Constructing two identical compile-time constants results in a single, canonical instance

```
var a = const ImmutablePoint(1, 1);
var b = const ImmutablePoint(1, 1);
assert(identical(a, b)); // They are the same instance!
```

* <WIP

### Next Plan

* Continue reading the [Language Tour](https://dart.dev/guides/language/language-tour)
* Classes
* Generics
* Libraries and visibility
* Asynchrony support
* Generators
* Callable classes
* Isolates
* Typedefs
* Metadata

### Reference

* A tour of the Dart language
[https://dart.dev/guides/language/language-tour](https://dart.dev/guides/language/language-tour) 
* Amazing Reason that Explain Why Flutter uses Dart!
[https://kodytechnolab.com/why-flutter-uses-dart](https://kodytechnolab.com/why-flutter-uses-dart) 
* Const, Static, Final, Oh my!
[https://news.dartlang.org/2012/06/const-static-final-oh-my.html](https://news.dartlang.org/2012/06/const-static-final-oh-my.html) 
* StatefulWidget class # Performance considerations
[https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html#performance-considerations](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html#performance-considerations)

