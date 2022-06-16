import 'package:json_to_dart_entity/dto_generator/dto_field.dart';

class DtoClassGenerator {
  const DtoClassGenerator({
    required String className,
    required this.fields,
    required this.generateFromJson,
    required this.generateToJson,
  }) : className = "${className}Dto";

  final String className;
  final List<DtoField> fields;
  final bool generateFromJson;
  final bool generateToJson;

  String generate() {
    final buffer = StringBuffer();

    _writeClassOpening(buffer);
    _writeConstructor(buffer);
    _writeLine(buffer);
    _writeFromJsonConstructor(buffer);
    _writeLine(buffer);
    _writeFields(buffer);
    _writeLine(buffer);
    _writeToJson(buffer);
    _writeClosing(buffer);

    return buffer.toString();
  }

  void _writeClassOpening(StringBuffer buffer) {
    _writeJsonSerializable(buffer);
    buffer.writeln("class $className {");
  }

  void _writeJsonSerializable(StringBuffer buffer) {
    buffer.write("@JsonSerializable(fieldRename: FieldRename.snake");
    if (!generateFromJson) {
      buffer.write(", createFactory: false");
    }
    if (!generateToJson) {
      buffer.write(", createToJson: false");
    }
    buffer.writeln(")");
  }

  void _writeConstructor(StringBuffer buffer) {
    buffer.writeln("  const $className({");
    for (final field in fields) {
      buffer.writeln("    required this.${field.name},");
    }
    buffer.writeln("  });");
  }

  void _writeFromJsonConstructor(StringBuffer buffer) {
    buffer.writeln("  factory $className.fromJson(Map<String, dynamic> json) => _\$${className}FromJson(json);");
  }

  void _writeFields(StringBuffer buffer) {
    for (final field in fields) {
      buffer.writeln("  final ${field.type} ${field.name};");
    }
  }

  void _writeToJson(StringBuffer buffer) {
    buffer.writeln("  Map<String, dynamic> toJson() => _\$${className}ToJson(this);");
  }

  void _writeClosing(StringBuffer buffer) {
    buffer.writeln("}");
  }

  void _writeLine(StringBuffer buffer) {
    buffer.writeln();
  }
}
