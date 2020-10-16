/// The `AddForm` is primarily meant for code-generation and used as part of the
/// `admin_template_generator` package.
///
/// A class implements this interface is considered a Form template and
/// `admin_template_generator` will generate the code needed based on the
/// templates are declared in the class.
abstract class AddForm<T> {}
