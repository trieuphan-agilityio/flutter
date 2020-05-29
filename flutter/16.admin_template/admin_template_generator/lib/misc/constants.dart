abstract class Annotation {
  static const agText = 'AgText';
  static const agBool = 'AgBool';
  static const agPassword = 'AgPassword';
  static const agEmail = 'AgEmail';
  static const agList = 'AgList<dynamic>';
}

abstract class FieldAnnotation {
  static const initialValue = 'initialValue';
  static const required = 'required';
  static const minLength = 'minLength';
  static const maxLength = 'maxLength';

  static const hintText = 'hintText';
  static const labelText = 'labelText';
  static const helperText = 'helperText';

  static const validator = 'validator';
  static const onSaved = 'onSaved';

  static const choices = 'choices';
}
