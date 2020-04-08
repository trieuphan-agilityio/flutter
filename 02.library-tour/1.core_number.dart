void main() {
  // --------------------------------------------
  // Numbers
  // --------------------------------------------

  // Convert an int to a string.
  assert(42.toString() == '42');

  // Convert a double to a string.
  assert(123.456.toString() == '123.456');

  // Specify the number of digits after the decimal.
  assert(123.456.toStringAsFixed(2) == '123.46');

  // Specify the number of significant figures.
  assert(123.456.toStringAsPrecision(2) == '1.2e+2');
  assert(double.parse('1.2e+2') == 120.0);

  // --------------------------------------------
  // Strings
  // --------------------------------------------

  var sampleStr = 'Never odd or even';

  // Check whether a string contains another string.
  assert(sampleStr.contains('odd'));

  // Does a string start another string?
  assert(sampleStr.startsWith('Never'));

  // Does a string end with another string?
  assert(sampleStr.endsWith('even'));

  // Find the location of a string inside a string.
  assert(sampleStr.indexOf('odd') == 6);

  // --------------------------------------------
  // Extract data from a string
  // --------------------------------------------

  // Grab a substring
  assert(sampleStr.substring(6, 9) == 'odd');

  // Split a string using a string pattern.
  var parts = 'structured web apps'.split(' ');
  assert(parts.length == 3);
  assert(parts[0] == 'structured');

  // Get a UTF-16 code unit (as a string) by index.
  assert(sampleStr[0] == 'N');

  // Use split() with an empty string parameter to get
  // a list of all characters (as Strings); good for
  // iterating.
  for (var char in 'hello'.split('')) {
    print(char);
  }

  // Get all the UTF-16 code units in the string.
  var codeUnitList = 'Never odd or even'.codeUnits.toList();
  assert(codeUnitList[0] == 78);

  // --------------------------------------------
  // Converting to uppercase or lowercase
  // --------------------------------------------

  // Convert to uppercase.
  assert(sampleStr.toUpperCase() == 'NEVER ODD OR EVEN');

  // Convert to lowercase.
  assert(sampleStr.toLowerCase() == 'never odd or even');

  // Trim a string.
  assert('  hello  '.trim() == 'hello');

  // Check whether a string is empty.
  assert(''.isEmpty);

  // Strings with only white space are not empty.
  assert('  '.isNotEmpty);

  // --------------------------------------------
  // Replacing part of a string
  // --------------------------------------------

  var greetingTemplate = 'Hello, NAME!';
  var greeting = greetingTemplate.replaceAll('NAME', 'Bob');

  // greetingTemplate didn't change.
  assert(greeting != greetingTemplate);

  // --------------------------------------------
  // Building a string
  // --------------------------------------------

  var sb = StringBuffer();
  sb
    ..write('Use a StringBuffer for ')
    ..writeAll(['efficient', 'string', 'creation'], ' ')
    ..write('.');

  var fullString = sb.toString();

  assert(fullString == 'Use a StringBuffer for efficient string creation.');

  // --------------------------------------------
  // Building a string
  // --------------------------------------------

  // Here's a regular expression for one or more digits.
  var numbers = RegExp(r'\d+');

  var allCharacters = 'llamas live fifteen to twenty years';
  var someDigits = 'llamas live 15 to 20 years';

  // contains() can use a regular expression.
  assert(!allCharacters.contains(numbers));
  assert(someDigits.contains(numbers));

  // Replace every match with another string.
  var exedOut = someDigits.replaceAll(numbers, 'XX');
  assert(exedOut == 'llamas live XX to XX years');

  // --------------------------------------------
  // Regular expressions
  // --------------------------------------------

  // Check whether the reg exp has a match in a string.
  assert(numbers.hasMatch(someDigits));

  // Loop through all matches.
  for (var match in numbers.allMatches(someDigits)) {
    print(match.group(0)); // 15, then 20
  }
}
