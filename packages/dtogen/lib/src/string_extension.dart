extension StringExtension on String {
  String firstCharToUpperCase() {
    if (isEmpty) {
      return "";
    }

    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String firstCharToLowerCase() {
    if (isEmpty) {
      return "";
    }

    return "${this[0].toLowerCase()}${substring(1)}";
  }

  String dtoNameToEntity() {
    return replaceAll("Dto", "");
  }

  String camelCaseToSnakeCase() {
    return splitByUpperCase().map((e) => e.toLowerCase()).join("_");
  }

  List<String> splitByUpperCase() {
    return split(RegExp("(?=[A-Z])"));
  }
}
