[training] 20200408 #dart

Hi Trung,

Today, I finished the Library Tour, I’m ready to move forward, please help me determine the next plan.

So far, I feel familiar with the language itself and I like it. In the Library Tour, I was introduced to the most commonly used functionality in Dart’s built-in libraries. It’s just a small excerpt of the libraries, there are many other useful libraries to explore such as Stream API, dart:collection and dart:test. I will take some time to learn them later. 

Below is my note today.

### Overview core libraries
* [dart:core](https://dart.dev/guides/libraries/library-tour#dartcore---numbers-collections-strings-and-more) Built-in types, collections, and other core functionality. ~This library is automatically imported into every Dart program.~
* [dart:async](https://dart.dev/guides/libraries/library-tour#dartasync---asynchronous-programming) Support for asynchronous programming, with classes such as Future and Stream.
I skipped this part because the Language Tour was covered quite a lot APIs of this package. I will find more content on internet to discover more later. 
* [dart:math](https://dart.dev/guides/libraries/library-tour#dartmath---math-and-random) Mathematical constants and functions.
* [dart:convert](https://dart.dev/guides/libraries/library-tour#dartconvert---decoding-and-encoding-json-utf-8-and-more) Encoders and decoders for converting between different data representations, including JSON and UTF-8.
* [dart:html](https://dart.dev/guides/libraries/library-tour#darthtml) DOM and other APIs for browser-based apps.
I bypassed this library since my focus is Dart/Flutter. 
* [dart:io](https://dart.dev/guides/libraries/library-tour#dartio) I/O for programs that can use the Dart VM, including Flutter apps, servers, and command-line scripts.

### dart:core

 - _dart:core_ provides critical set of built-in functionality to work with _numbers_, _collections_, _strings_, and more

**Numbers**

* Use _print()_ to display object’s string value in the console
* Use _parse() _ methods of _integer_ or _double_ to convert a string
* ~Use _parse()_ method of _num_ to convert a string to an integer if possible and otherwise a double~

```
assert(num.parse('42') is int);
assert(num.parse('0x42') is int);
assert(num.parse('0.50') is double);
```

* To specify the base of integer, add a radix parameter when parsing string

```
assert(int.parse('42', radix: 16) == 66);
```

* Use _toString()_ to convert an _int_ or _double_ to a string. To specify number of digits after the decimal use _toStringAsFixed()_

```
// Convert an int to a string.
assert(42.toString() == '42');

// Convert a double to a string.
assert(123.456.toString() == '123.456');

// Specify the number of digits after the decimal.
assert(123.456.toStringAsFixed(2) == '123.46');
```

_Strings and regular expressions_

* A string in Dart is an immutable sequence of UTF-16 code units
* Search string with _split()_, _contains()_, _startsWith()_, _endsWith()_.
* Extract data from a string with _substring()_, _split()_.
* Convert to uppercase or lowercase with _toUpperCase()_, _toLowerCase()_
* Trim and check empty string with _trim()_, _isEmpty()_, _isNotEmpty()_

_Replacing part of a string_

* Strings are immutable objects, which means you can create them but you can’t change. In String API, none none of the methods actually changes the state of a String.
* Use _replaceAll()_ to return a new String with apart is replaced.

```
var greetingTemplate = 'Hello, NAME!';
var greeting =
    greetingTemplate.replaceAll(RegExp('NAME'), 'Bob');

// greetingTemplate didn't change.
assert(greeting != greetingTemplate);
```

_Building a string_

* Use _StringBuffer_ to build a string
* _StringBuffer_ doesn’t generate a new String object until _toString()_ is called

```
var sb = StringBuffer();
sb
  ..write('Use a StringBuffer for ')
  ..writeAll(['efficient', 'string', 'creation'], ' ')
  ..write('.');

var fullString = sb.toString();

assert(fullString ==
    'Use a StringBuffer for efficient string creation.');
```

_Regular expressions_

* The RegExp class provides the same capabilities as JavaScript regular expressions.
* String has methods that works with RegExp such as 
	1. _contains(RegExp)_: to test if string match a pattern
	2. _replaceAll(Regexp, String)_: to replace every match with another string
* RegExp simple sample

```
var numbers = RegExp(r'\d+');
var someDigits = 'llamas live 15 to 20 years';

// Check whether the reg exp has a match in a string.
assert(numbers.hasMatch(someDigits));

// Loop through all matches.
for (var match in numbers.allMatches(someDigits)) {
  print(match.group(0)); // 15, then 20
}
```

**Collections**

*Lists*

* Alternative to List literal, you can use one of the List constructors to create a List

```
// create a list with literal
var fruits = ['apples', 'oranges'];

// create a list with constructor
var vegetables = List();
```

* sort a list

```
fruits.sort((a, b) => a.compareTo(b));
```

* create a list of specific type

```
var fruits = List<String>();
```

* more sample of list

```
// Use a List constructor.
var vegetables = List();

// Or simply use a list literal.
var fruits = ['apples', 'oranges'];

// Add to a list.
fruits.add('kiwis');

// Add multiple items to a list.
fruits.addAll(['grapes', 'bananas']);

// Get the list length.
assert(fruits.length == 5);

// Remove a single item.
var appleIndex = fruits.indexOf('apples');
fruits.removeAt(appleIndex);
assert(fruits.length == 4);

// Remove all elements from a list.
fruits.clear();
assert(fruits.isEmpty);
```

*Sets*

* A set in Dart is an unordered collection of unique items.

```
var ingredients = Set();
ingredients.addAll(['gold', 'titanium', 'xenon']);
assert(ingredients.length == 3);

// Adding a duplicate item has no effect.
ingredients.add('gold');
assert(ingredients.length == 3);

// Remove an item from a set.
ingredients.remove('gold');
assert(ingredients.length == 2);
```

* Use _contains()_ and _containsAll()_ to check whether one or more objects are in a set

* An intersection is a _set_ whose items are in two other sets.

```
var ingredients = Set();
ingredients.addAll(['gold', 'titanium', 'xenon']);

// Create the intersection of two sets.
var nobleGases = Set.from(['xenon', 'argon']);
var intersection = ingredients.intersection(nobleGases);
assert(intersection.length == 1);
assert(intersection.contains('xenon'));
```

*Maps*

* A map, commonly known as a dictionary or hash, is an unordered collection of key-value pairs.
* Unlike in JavaScript, Dart objects are not maps.
* Map example

```
// Maps often use strings as keys.
var hawaiianBeaches = {
  'Oahu': ['Waikiki', 'Kailua', 'Waimanalo'],
  'Big Island': ['Wailea Bay', 'Pololu Beach'],
  'Kauai': ['Hanalei', 'Poipu']
};

// Maps can be built from a constructor.
var searchTerms = Map();

// Maps are parameterized types; you can specify what
// types the key and value should be.
var nobleGases = Map<int, String>();
```

* Common Map  API: 
	1. containsKey(): check whether a map contains a key
	2. remove(): remove a key and its value
	3. keys: get all the keys as an unordered collection
	4. values: get all the values as an unordered collection
	5. putIfAbsent: assign a value only if the key does not exist. You must provide a function that returns the value

*Common collection methods*

* use _isEmpty_, _isNotEmpty_ to check whether a list, set, or map has items
* use _forEach_ to apple a function to each item
* use _map_ to transform a list, set, or map
* use _where()_ to get all items that match a condition
* use _any()_ to check whether at least one item satisfies a condition
* use _every()_ to check whether all items satisfy a condition

**URIs**

* *Uri class* provides functions to encode and decode string for use in URIs (common know as URLs)
* It handles special characters on URI, such as _&_ and _=_
* It also parses and exposes the components of a URI — host, port, scheme, path, fragment, and origin.

**Dates and times**

* There are several constructors to create DateTime objects. E.g:

```
// Get the current date and time.
var now = DateTime.now();

// Create a new DateTime with the local time zone.
var y2k = DateTime(2000); // January 1, 2000

// Specify the month and day.
y2k = DateTime(2000, 1, 2); // January 2, 2000

// Specify the date as a UTC time.
y2k = DateTime.utc(2000); // 1/1/2000, UTC

// Specify a date and time in ms since the Unix epoch.
y2k = DateTime.fromMillisecondsSinceEpoch(946684800000,
    isUtc: true);

// Parse an ISO 8601 date.
y2k = DateTime.parse('2000-01-01T00:00:00Z');
```

* Use _Duration_ class to calculate the difference between two dates and to shift a date forward or backward.

**Exceptions**

* Exceptions are considered conditions that you can plan ahead for and catch. Errors are conditions that you don’t expect or plan for.
* A couple of the most common errors are:
	1. NoSuchMethodError: thrown when a receiving object does not implement a method
	2. ArgumentError: can be thrown by a method that encounters an unexpected argument
* Define a custom exception by implementing the Exception interface

```
class FooException implements Exception {
  final String msg;

  const FooException([this.msg]);

  @override
  String toString() => msg ?? 'FooException';
}
```

### dart:math - math and random

* *dart:math* provides common functionality such as sine cosine, maximum, and constants such as _pi_ and _e_.
* Most of the functionality in _dart:math_ is implemented as top-level function.
* To use this library, import dart:math

```
import 'dart:math'
```

* basic trigonometric  functions, such as _cos_, _sin_, _acos_, _asin_ and _tan_
* _min_, _max_
* constants - _pi_, _e_, _sqrt2_
* random numbers with _Random_ class , e.g

```
var random = Random();
random.nextDouble(); // Between 0.0 and 1.0: [0, 1)
random.nextInt(10); // Between 0 and 9.
```

### dart:convert

* _dart:convert_ has converters for JSON and UTF-8, as well as support for creating additional converters.
* To use this library, import dart:convert

```
import 'dart:convert'
```

*Decoding and encodingJSON*

* use _jsonDecode()_ to ecode a JSON-encoded string into a Dart object, e.g:

```
var jsonString = '''
  [
    {"score": 40},
    {"score": 80}
  ]
''';

var scores = jsonDecode(jsonString);
assert(scores is List);

var firstScore = scores[0];
assert(firstScore is Map);
assert(firstScore['score'] == 40);
```

* Only objects of type _int_, _double_, _String_, _bool_, _null_, _List_, or _Map_ (with string keys) are directly encodable into JSON.
* List and Map objects are encoded recursively.

### dart:io - I/O for servers and command-line apps

* _dart:io_ provides APIs to deal with files, directories, processes, sockets, WebSockets, and HTTP clients and servers
* In general, the _dart:io_ library implements and promotes an asynchronous API. Synchronous methods can easily block an application, making it difficult to scale. Therefore, most operations return results via Future or Stream objects.
* synchronous methods in the _dart:io_ library are marked with a Sync suffix on the method name. E.g: 

```
void createSync({bool recursive: false});
File renameSync(String newPath);
File copySync(String newPath);
int lengthSync();
```

* To use this library declare import ‘dart:io’

```
import 'dart:io'
```

**Files and directories**

* The I/O library enables command-line apps to read and write files and browse directories.
* You have two choices for reading the contents of a file: all at once, or streaming.
* Reading a file all at once requires enough memory to store all the contents of the file. If the file is very large or you want to process it while reading it, you should use a Stream.

*Reading a file as text*

* Use _readAsString()_ to read entire file contents at once
* Use _readAsLines()_ to read line-by-line
* Use _readAsBytes()_ to read entire file contents as bytes into a list of ints.

```
Future main() async {
  var config = File('config.txt');
  var contents;

  // Put the whole file in a single string.
  contents = await config.readAsString();
  print('The file is ${contents.length} characters long.');

  // Put each line of the file into its own string.
  contents = await config.readAsLines();
  print('The file is ${contents.length} lines long.');
}
```

*Streaming file contents*

* Use either the _Stream_ API or _await for_ to read a file as stream. E.g:

```
import 'dart:io';
import 'dart:convert';

Future main() async {
  var config = File('config.txt');
  Stream<List<int>> inputStream = config.openRead();

  var lines = utf8.decoder
    .bind(inputStream)
    .transform(LineSplitter());
  try {
    await for (var line in lines) {
      print('Got ${line.length} characters from stream');
    }
    print('file is now closed');
  } catch (e) {
    print(e);
  }
}
```

*Writing file contents*

* Use the File openWrite() method to get an IOSink that you can write to. The default mode, FileMode.write, completely overwrites existing data in the file. E.g:

```
var logFile = File('log.txt');
var sink = logFile.openWrite();
sink.write('FILE ACCESSED ${DateTime.now()}\n');
await sink.flush();
await sink.close();
```

* To add to the end of the file, use the optional mode parameter to specify FileMode.append:

```
var sink = logFile.openWrite(mode: FileMode.append);
```

*Listing files in a directory*

* Finding all files and subdirectories for a directory is an asynchronous operation. The _list()_ method returns a Stream that emits an object when a file or directory is encountered.

```
Future main() async {
  var dir = Directory('tmp');

  try {
    var dirList = dir.list();
    await for (FileSystemEntity f in dirList) {
      if (f is File) {
        print('Found file ${f.path}');
      } else if (f is Directory) {
        print('Found dir ${f.path}');
      }
    }
  } catch (e) {
    print(e.toString());
  }
}
```

**HTTP clients and servers**

*  `dart:io` library provides classes that command-line apps can use for accessing HTTP resources, as well as running HTTP servers.

### GIT
* Remote:  [git@gitlab.asoft-python.com:g-sangdong/swift-training.git]()
* Folder: 02.library-tour


Thank you,
