void runList() {
  // --------------------------------------------
  // Lists
  // --------------------------------------------

  // Use a List constructor.
  var vegetables = List();

  // Or simply use a lst literal.
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
}

void runSet() {
  // --------------------------------------------
  // Sets
  // --------------------------------------------

  var ingredients = Set();
  ingredients.addAll(['gold', 'titanium', 'xenon']);

  // Create the intersection of two sets.
  var nobleGases = Set.from(['xenon', 'argon']);
  var intersection = ingredients.intersection(nobleGases);
  assert(intersection.length == 1);
  assert(intersection.contains('xenon'));
}

void runMap() {
  // --------------------------------------------
  // Maps
  // --------------------------------------------

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

  var teamAssignments = {};
  teamAssignments.putIfAbsent('Catcher', () => "John");
  assert(teamAssignments['Catcher'] != null);
}

void main() {
  runList();
  runSet();
  runMap();
}
