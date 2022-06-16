import 'package:json_to_dart_entity/dto_generator/dto_field.dart';
import 'package:json_to_dart_entity/dto_generator/string_extension.dart';
import 'package:meta/meta.dart';

abstract class ClassGenerator {
  const ClassGenerator({
    required this.className,
    required this.fields,
  });

  final String className;
  final List<ClassField> fields;

  String generate() {
    final buffer = StringBuffer();
    generateClass(buffer);
    return buffer.toString();
  }

  void generateClass(StringBuffer buffer);

  @protected
  void writeClassDeclaration(
    StringBuffer buffer, {
    String? annotation,
    String? extend,
  }) {
    if (annotation != null) {
      buffer.writeln(annotation);
    }

    buffer.write("class $className ");
    if (extend != null) {
      buffer.write("extends $extend ");
    }
    buffer.writeln("{");
  }

  @protected
  void writeConstructor(StringBuffer buffer) {
    buffer.writeln("  const $className({");
    for (final field in fields) {
      buffer.writeln("    required this.${field.name},");
    }
    buffer.writeln("  });");
  }

  @protected
  void writeFields(StringBuffer buffer) {
    for (final field in fields) {
      buffer.writeln("  final ${field.type} ${field.name};");
    }
  }

  @protected
  void writeClosing(StringBuffer buffer) {
    buffer.writeln("}");
  }

  @protected
  void writeLine(StringBuffer buffer) {
    buffer.writeln();
  }
}

class DtoClassGenerator extends ClassGenerator {
  const DtoClassGenerator({
    required String className,
    required super.fields,
    required this.generateFromJson,
    required this.generateToJson,
    required this.generateFromEntity,
    required this.generateToEntity,
  }) : super(className: "${className}Dto");

  final bool generateFromJson;
  final bool generateToJson;

  final bool generateFromEntity;
  final bool generateToEntity;

  static const _jsonType = "Map<String, dynamic>";

  @override
  void generateClass(StringBuffer buffer) {
    writeClassDeclaration(buffer, annotation: _jsonSerializableAnnotation);
    writeConstructor(buffer);
    writeLine(buffer);
    _writeFromJsonConstructor(buffer);
    writeLine(buffer);
    if (generateFromEntity) {
      _writeFromEntityFactory(buffer);
      writeLine(buffer);
    }
    writeFields(buffer);
    writeLine(buffer);
    if (generateToEntity) {
      _writeToEntityMethod(buffer);
      writeLine(buffer);
    }
    _writeToJsonMethod(buffer);
    writeClosing(buffer);
  }

  String get _jsonSerializableAnnotation {
    final annotationBuffer = StringBuffer("@JsonSerializable(fieldRename: FieldRename.snake");
    if (!generateFromJson) {
      annotationBuffer.write(", createFactory: false");
    }
    if (!generateToJson) {
      annotationBuffer.write(", createToJson: false");
    }
    annotationBuffer.write(")");
    return annotationBuffer.toString();
  }

  void _writeFromEntityFactory(StringBuffer buffer) {
    final entityName = className.dtoNameToEntity();
    buffer.writeln("  factory $className.fromEntity($entityName entity) {");
    buffer.writeln("    return $className(");
    for (final field in fields) {
      String fieldValue = "entity.${field.name}";
      final fieldDateValue = field.date;
      if (fieldDateValue != null) {
        fieldValue = "$fieldValue.toString()";
      } else if (field.isList) {
        fieldValue = "$fieldValue.map(${field.genericType}.fromEntity).toList()";
      }
      buffer.writeln("      ${field.name}: $fieldValue,");
    }
    buffer.writeln("    );");
    buffer.writeln("  }");
  }

  void _writeToEntityMethod(StringBuffer buffer) {
    final entityName = className.dtoNameToEntity();
    buffer.writeln("  $entityName toEntity() {");
    buffer.writeln("    return $entityName(");
    for (final field in fields) {
      String fieldValue = field.name;
      final fieldDateValue = field.date;
      if (fieldDateValue != null) {
        fieldValue = "DateTime.parse($fieldValue)";
      } else if (field.isList) {
        fieldValue = "$fieldValue.map((e) => e.toEntity()).toList()";
      }

      buffer.writeln("      ${field.name}: $fieldValue,");
    }
    buffer.writeln("    );");
    buffer.writeln("  }");
  }

  void _writeFromJsonConstructor(StringBuffer buffer) {
    buffer.writeln("  factory $className.fromJson($_jsonType json) => _\$${className}FromJson(json);");
  }

  void _writeToJsonMethod(StringBuffer buffer) {
    buffer.writeln("  $_jsonType toJson() => _\$${className}ToJson(this);");
  }
}

class EntityClassGenerator extends ClassGenerator {
  EntityClassGenerator({
    required super.className,
    required List<ClassField> fields,
    required this.addCopyWith,
  }) : super(
          fields: fields.map(_mapDtoFieldToEntity).toList(),
        );

  final bool addCopyWith;

  @override
  void generateClass(StringBuffer buffer) {
    writeClassDeclaration(
      buffer,
      annotation: addCopyWith ? "@CopyWith()" : null,
      extend: "Equatable",
    );
    writeConstructor(buffer);
    writeLine(buffer);
    writeFields(buffer);
    writeLine(buffer);
    _writeProperties(buffer);
    writeClosing(buffer);
  }

  void _writeProperties(StringBuffer buffer) {
    buffer.writeln("  @override");
    buffer.writeln("  List<Object?> get props => [");
    for (final field in fields) {
      buffer.writeln("        ${field.name},");
    }
    buffer.writeln("      ];");
  }

  /// Maps string class field to the date class field.
  static ClassField _mapDtoFieldToEntity(ClassField classField) {
    final date = classField.date;
    if (date != null) {
      return classField.copyWith(type: "DateTime");
    }
    return classField.copyWith(type: classField.type.dtoNameToEntity());
  }
}
