import 'base.dart';

part 'person_form.g.dart';

class Person {
  final String fullName;
  final int age;

  const Person(this.fullName, this.age);
}

class PersonEditingModel {
  final String firstName;
  final String lastName;
  final int age;

  const PersonEditingModel(this.firstName, this.lastName, this.age);
}

class PersonEditing = _PersonEditing with _$PersonEditing;

abstract class _PersonEditing with Form<Person> {
  FormFieldBuilder<int> get ageBuilder => FormFieldBuilder<int>()
    ..helpText('Person age')
    ..range(0, 10)
    ..nullable();
}
