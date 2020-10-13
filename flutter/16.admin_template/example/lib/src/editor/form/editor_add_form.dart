import '../editor.dart';

class FormField<T> {}

class FieldBuilder<T> {
  int minLength;
  int maxLength;
  T initialValue;
  bool isRequired;
  String hintText;
  String labelText;
  String helperText;

  FormField<T> build<T>() {
    FormField<T> field = FormField();
    return field;
  }
}

class EditForm {
  const EditForm.of(Type modelType);
}

abstract class AddForm<ModelType> {}

class EditEditingForm implements AddForm<Editor> {}

class EditorAddForm implements AddForm<Editor> {
  FormField<String> get firstName {
    final builder = FieldBuilder<String>()
      ..isRequired = true
      ..helperText = 'Editor\'s first name';

    return builder.build();
  }

  FormField<String> get bio {
    final builder = FieldBuilder<String>()
      ..maxLength = 150
      ..hintText = 'Tell us about yourself'
          ' (e.g., write down what you do or what hobbies you have)'
      ..helperText = 'Keep it short, this is just a demo.'
      ..labelText = 'Life story';

    return builder.build();
  }

  FormField<Iterable<String>> get roles {
    final builder = FieldBuilder<Iterable<String>>()
      ..isRequired = true
      ..labelText = 'Roles'
      ..initialValue = EditorRole.values.map((e) => e.toString());

    return builder.build();
  }
}

class EditorAddModel {
  final String firstName;

  final String lastname;

  final Iterable<String> roles;

  EditorAddModel({
    this.firstName,
    this.lastname,
    this.roles,
  });

  EditorAddModel copyWith({
    String firstName,
    String lastname,
    Iterable<String> roles,
  }) {
    return EditorAddModel(
      firstName: firstName ?? this.firstName,
      lastname: lastname ?? this.lastname,
      roles: roles ?? this.roles,
    );
  }
}
