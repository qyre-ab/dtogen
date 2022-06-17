class ClassField {
  ClassField({
    required this.type,
    required this.name,
    required this.value,
  });

  final String type;
  final String name;
  final Object value;

  late final DateTime? date = _tryParseFromValue();

  late final isList = type.startsWith("List");
  late final genericType = _getGenericType();
  late final primitiveType = isPrimitiveType(type);

  static const primitiveTypes = ['int', 'String', 'double', 'bool'];

  String _getGenericType() {
    return type.replaceAll("List<", "").replaceAll(">", "");
  }

  DateTime? _tryParseFromValue() {
    final val = value;
    if (val is String) {
      return DateTime.tryParse(val);
    }
    return null;
  }

  ClassField copyWith({String? type, String? name, Object? value}) {
    return ClassField(
      type: type ?? this.type,
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }
}

bool isPrimitiveType(String type) {
  return ClassField.primitiveTypes.contains(type);
}
