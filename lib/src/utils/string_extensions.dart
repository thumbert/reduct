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
  ///  * "so2_mass" -> "so2_mass"
  ///  * "so2Mass" -> "so2_mass"
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
    // Insert underscore before digits that are embedded within a word
    // (i.e., followed by more letters): "start15min" -> "start_15min".
    // The lookahead (?=[A-Za-z]) ensures digits at the end of a lowercase
    // token (e.g. "so2" in "so2_mass") are left untouched.
    s = s.replaceAllMapped(
      RegExp(r'([A-Za-z]{2,})([0-9]+)(?=[A-Za-z])'),
      (m) => '${m.group(1)}_${m.group(2)}',
    );
    // Split uppercase acronyms from trailing digits: "ARA1" -> "ARA_1".
    s = s.replaceAllMapped(
      RegExp(r'([A-Z]{2,})([0-9]+)'),
      (m) => '${m.group(1)}_${m.group(2)}',
    );
    // For sequences where a single letter is followed by digits and then
    // letters (e.g. `y1axis`), keep the single letter attached to the
    // digits and insert an underscore before the following letters to
    // produce `y1_axis`.
    s = s.replaceAllMapped(
      RegExp(r'([A-Za-z])([0-9]+)([A-Za-z]+)'),
      (m) => '${m.group(1)}${m.group(2)}_${m.group(3)}',
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
