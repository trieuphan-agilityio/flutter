[training] 20200407 #dart

Hi Trung,

Today I finished the Language Tour, please see my notes below:

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

* A superclass’s named constructor is not inherited by a subclass
* Use _named constructor_ to implement multiple constructors for a class or to provide extra clarity

```
class Point {
  final num x, y;

  Point(this.x, this.y);
  
  // Named constructor with initializer list
  Point.origin()
      : x = 0,
        y = 0;
}
```

* By default, a constructor in a subclass calls the superclass’s unnamed, no-argument constructor. The order of execution is as follow:
	1. initializer list
	2. superclass’s no-arg constructor
	3. main class’s no-arg constructor
* If the superclass doesn’t have default constructor, it’s required to call one of the constructors in the superclass 

*Initializer*

* The right-hand side of an initializer does not have access to this.
* Can validate inputs of a constructor by using assert in the initializer list

```
Point.withAssert(this.x, this.y) : assert(x >= 0) {
  print(‘In Point.withAssert(): ($x, $y)’);
}
```

* Initializer lists are used to set up final fields.

```
class Point {
  final num x, y, distanceFromOrigin;
  Point(x, y)
      : x = x,
        y = y,
        distanceFromOrigin = sqrt(x * x + y * y);
}
```

*Constant constructors*

* Constant constructors don’t always create constants.
* E.g:

```
class ImmutablePoint {
  static final ImmutablePoint origin =
      const ImmutablePoint(0, 0);

  final num x, y;

  const ImmutablePoint(this.x, this.y);
}
```

*Factory constructors*

* Use *factory* keyword when implementing a constructor that doesn’t always create a new instance of its class.
* For example, a factory constructor might return an instance from a cache, or it might return an instance of a subtype.

*Implicit interfaces*

* ~Every class implicitly defines an interface containing all the instance members of the class and of any interfaces it implements.~

*Override members*

* Subclasses can override instance methods, getters, and setters. In Dart, every class property has implicit getters/setters, therefore subclass can override it as well.

*noSuchMethod()*

* To detect or react whenever code attempts to use a non-existent method or instance variable
* You can invoke an unimplemented method if:
	* The receiver has the static type dynamic.

```
class Person {
  @override
  void noSuchMethod(Invocation invocation) =>
      ‘Got the ${invocation.memberName}’;
}

void main(List<String> args) {
  dynamic person = Person();
  print(person.missing(’20’, ‘josephine’));
}
```

	* The receiver has a static type that defines the unimplemented method (abstract is OK), and the dynamic type of the receiver has an implemention of noSuchMethod() that’s different from the one in class Object.

```
class Person {
  void missing(int age, String name);

  @override //overriding noSuchMethod
  void noSuchMethod(Invocation invocation) =>
      ‘Got the ${invocation.memberName}’;
}

void main(List<String> args) {
  dynamic person = Person();
  print(person.missing(20, ‘shubham’));
}
```

**Enumerated types**

* Using enums

```
enum Color { red, green, blue }
```

* enum has an index getter, which returns the zero-based position of the value in the enum declaration

```
assert(Color.red.index == 0);
assert(Color.green.index == 1);
assert(Color.blue.index == 2);
```

* To get a list of all of the values in the enum, use the enum’s _values_ constant

```
List<Color> colors = Color.values;
assert(colors[2] == Color.blue);
```

**Mixins**

* Mixins are a way of reusing a class’s code in multiple class hierarchies.
* We can specify certain types that can use mixins. Use _on_ to specify the required superclass.

```
mixin MusicalPerformer on Musician {
  // …
}
```

* Mixins in Dart work by creating a new class that layers the implementation of the mixins on top of a superclass to create a new class — it is not “on the side” but “on top” of the superclass, so there is no ambiguity in how to resolve lookups.
* E.g:

```
class A extends B with C, D {}
```

is semantically equivalent to

```
class BC = B with C;
class BCD = BC with D;
class A extends BCD {}
```

follow code block will print out “Hello World from D”

```
abstract class B {
  String get world => ‘World’;
}

mixin C {
  void hello(String name) => print(‘Hello $name from C’);
}

mixin D {
  void hello(String name) => print(‘Hello $name from D’);
}

class A extends B with C, D {}

void main() {
  final a = A();
  a.hello(a.world);
}
```

* Mixins is not a way to get multiple inheritance in the classical sense. Mixins is a way to abstract and reuse a family of operations and state.
* ~If you name a mixin application like *class CSuper = Super with Mixin {}*, then you can refer to the mixin application class and its interface, and it will be a sub-type of both *Super* and *Mixin*.~
* Mixins can have variables.
* Mixins is just a class was designed to be “mixed in”, rather than used stand alone.

**Libraries and visibility**

_Using libraries_

* Use import to specify how a namespace from one library is used in the scope of another library.
* For built-in libraries, the URI has the special `dart:` scheme

```
import ‘dart:html’;
```

* The `package:` scheme specifies libraries provided by a package manager such as the pub tool

```
import ‘package:test/test.dart’;
```

* Specify a prefix to import two libraries that have conflicting identifiers. E.g:

```
import ‘package:lib1/lib1.dart’;
import ‘package:lib2/lib2.dart’ as lib2;

// Uses Element from lib1.
Element element1 = Element();

// Uses Element from lib2.
lib2.Element element2 = lib2.Element();
```

* Importing only part of a library

```
// Import only foo.
import ‘package:lib1/lib1.dart’ show foo;

// Import all names EXCEPT foo.
import ‘package:lib2/lib2.dart’ hide foo;
```

_Lazily loading a library_

* *Deferred loading* (aka *lazy loading*) allows a web app to load a library on demand, if and when the library is needed
* Only dart2js supports deferred loading
* E.g:

```
import ‘package:greetings/hello.dart’ deferred as hello;
```

**Asynchrony support**

_Handling Futures_

* Dart supports _Future_ and _Stream_  as its standard library.
* With _async_ and _await_ you can Dart asynchronous code just like synchronous code.
* E.g: 

```
Future checkVersion() async {
  var version = await lookUpVersion();
  // Do something with version
}
```

* Can handle async error with try/catch, e.g:

```
try {
  version = await lookUpVersion();
} catch (e) {
  // React to inability to look up the version
}
```

* If async function don't return a useful value, it must return _Future<void>_

_Handling Streams_

* There are two options to get values from a Stream: use _await for_ or use stream API.
* Example of using asynchronous for loop (_await for_) to get values from a Stream:

```
await for (varOrType identifier in expression) {
  // Executes each time the stream emits a value.
}
```

Execution proceeds as follows:
	1. Wait until the stream emits a value.
	2. Execute the body of the for loop, with the variable set to that emitted value.
	3. Repeat 1 and 2 until the stream is closed.

To stop listening to the stream, you can use a _break_ or _return_ statement, which breaks out of the for loop and unsubscribes from the stream.

More detail about asynchronous programming will be covered on [dart:async](https://dart.dev/guides/libraries/library-tour#dartasync---asynchronous-programming)  section of the library tour.

**Generators**

* Use generator function to lazily produce a sequence of values. 
* Dart has built-in support for two kinds of generator functions:
	* _Synchronous_ generator: Returns an [Iterable](https://api.dart.dev/stable/dart-core/Iterable-class.html) object.

```
Iterable<int> naturalsTo(int n) sync* {
  int k = 0;
  while (k < n) yield k++;
}
```

	* _Asynchronous_ generator: Returns a [Stream](https://api.dart.dev/stable/dart-async/Stream-class.html) object.

```
Stream<int> asynchronousNaturalsTo(int n) async* {
  int k = 0;
  while (k < n) yield k++;
}
```

* If the generator is recursive, you can improve its performance by using _yield*_

**Callable classes**

* Class implement the call() method is _Callable classes_. It allows an its instance can be called like a function.
* _Callable classes_ can be used to declare a stateful function.
* E.g:

```
class MockOnPressedFunction implements Function {
  int called = 0;
  void call() {
    called++;
  }
}

var mockOnPressedFunction = MockOnPressedFunction();

IconButton(
  onPressed: mockOnPressedFunction,
  icon: const Icon(Icons.link),
);

expect(mockOnPressedFunction.called, 0);
```

**Isolates**

* Instead of threads, all Dart code runs inside of _isolates_.
* Each isolate has its own memory heap, ensuring that no isolate’s state is accessible from any other isolate.

**Typedef**

* _typedef_, or _function-type alias_, gives a function type a name
* A typedef retains type information when a function type is assigned to a variable
* E.g:

```
typedef Compare = int Function(Object a, Object b);

class SortedCollection {
  Compare compare;
  SortedCollection(this.compare);
}

// Initial, broken implementation.
int sort(Object a, Object b) => 0;

void main() {
  SortedCollection coll = SortedCollection(sort);
  assert(coll.compare is Function);
  assert(coll.compare is Compare);
}
```

* Currently, _typedefs_ are restricted to function types. It’s the subject to change.

**Metadata**

* Use metadata to give additional information about the code
* A metadata annotation begins with the character @, followed by either a reference to a compile-time constant (such as deprecated) or a call to a constant constructor
* Two annotations are available to all Dart code: @deprecated and @override
* There are few other useful annotations in `meta` package: 
	* alwaysThrows
	* checked
	* experimental
	* factory
	* immutable
	* isTest
	* isTestGroup
	* literal
	* mustCallSuper
	* nonVirtual
	* optionalTypeArgs
	* protected
	* required
	* sealed
	* virtual
	* visibleForTesting

### Reference
* [Dart: What are mixins? - Flutter Community - Medium](https://medium.com/flutter-community/dart-what-are-mixins-3a72344011f3)
* [When to use mixins and when to use interfaces in Dart? - Stack Overflow](https://stackoverflow.com/questions/45901297/when-to-use-mixins-and-when-to-use-interfaces-in-dart/45903671#45903671)
* [Mixin vs inheritance - Stack Overflow](https://stackoverflow.com/questions/860245/mixin-vs-inheritance/860312#860312)
* [sdk/meta.dart at master · dart-lang/sdk · GitHub](https://github.com/dart-lang/sdk/blob/master/pkg/meta/lib/meta.dart)

### Next Plan
* Take the tour of the core libraries at [Library tour | Dart](https://dart.dev/guides/libraries/library-tour)
