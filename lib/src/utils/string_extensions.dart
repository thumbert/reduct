extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  bool isUpperCase() {
    return this == toUpperCase();
  }

  String toCamelCase() {
    if (isEmpty) return this;

    // Split the string into words based on spaces, underscores, and hyphens
    List<String> words = replaceAll(
      RegExp(r'[_\-\s]+'),
      ' ',
    ).split(' ').where((word) => word.isNotEmpty).toList();

    // Lowercase the first word and capitalize the first letter of subsequent words
    String camelCaseString =
        words[0].toLowerCase() +
        words.skip(1).map((word) => word.capitalize()).join('');

    return camelCaseString;
  }

  /// Converts a string to PascalCase.
  /// Handles strings with spaces, underscores, and hyphens as word separators.
  /// Examples:
  ///   "hello world" -> "HelloWorld"
  ///   "hello_world" -> "HelloWorld"
  ///   "hello-world" -> "HelloWorld"
  String toPascalCase() {
    // Replace common separators with spaces and convert to lowercase
    String formattedInput = replaceAll(RegExp(r'[_-]'), ' ').toLowerCase();

    // Split the string into words
    List<String> words = formattedInput.split(' ');

    // Capitalize the first letter of each word and join them
    String pascalCaseString = words
        .map((word) {
          if (word.isEmpty) {
            return '';
          }
          return word[0].toUpperCase() + word.substring(1);
        })
        .join('');

    return pascalCaseString;
  }

  /// Converts a string to snake_case.
  /// Examples:
  ///  * "hello World" -> "hello_world"
  ///  * "helloWorld" -> "hello_world"
  ///  * "HelloWorld" -> "hello_world"
  ///  * "ARA1" -> "ara_1"
  ///  * "Start15min" -> "start_15min"
  String toSnakeCase() {
    // Insert underscore before every uppercase letter (except at the start),
    // and between letters and numbers, then lowercase
    String s = this;
    s = s.replaceAllMapped(
      RegExp(r'([a-z0-9])([A-Z])'),
      (m) => '${m.group(1)}_${m.group(2)}',
    );
    s = s.replaceAllMapped(
      RegExp(r'([A-Z]+)([A-Z][a-z])'),
      (m) => '${m.group(1)}_${m.group(2)}',
    );
    // Insert underscore before a run of digits when preceded by a letter
    s = s.replaceAllMapped(
      RegExp(r'([A-Za-z])([0-9]+)'),
      (m) => '${m.group(1)}_${m.group(2)}',
    );
    s = s.replaceAll(RegExp(r'[\s\-]+'), '_');
    s = s.replaceAll(RegExp(r'_+'), '_');
    s = s.toLowerCase();
    s = s.replaceAll(RegExp(r'^_+|_+$'), '');
    return s;
  }

  /// Converts a string from camelCase to UPPER_SNAKE_CASE.
  /// Examples:
  ///   "hello World" -> "HELLO_WORLD"
  ///   "helloWorld" -> "HELLO_WORLD"
  ///   "HelloWorld" -> "HELLO_WORLD"
  ///   "hello_world" -> "HELLO_WORLD"
  ///   "ARA1" -> "ARA_1"
  String toUpperSnakeCase() {
    return toSnakeCase().toUpperCase();
  }
}
