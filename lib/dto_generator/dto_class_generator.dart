
import 'package:dtogen/dto_generator/class_generator.dart';
import 'package:dtogen/dto_generator/dto_field.dart';
import 'package:dtogen/dto_generator/string_extension.dart';

class DtoGenerator extends ClassGenerator {
  const DtoGenerator({
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
    if (generateFromJson) {
      _writeFromJsonConstructor(buffer);
      writeLine(buffer);
    }
    if (generateFromEntity) {
      _writeFromEntityFactory(buffer);
      writeLine(buffer);
    }
    writeFields(buffer);
    if (generateToEntity) {
      writeLine(buffer);
      _writeToEntityMethod(buffer);
    }
    if (generateToJson) {
      writeLine(buffer);
      _writeToJsonMethod(buffer);
    }
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
        final genericType = field.genericType;
        if (!isPrimitiveType(genericType)) {
          fieldValue = "$fieldValue.map(${field.genericType}.fromEntity).toList()";
        }
      } else if (!field.primitiveType) {
        fieldValue = "${field.type}.fromEntity(entity.${field.name})";
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
        final genericType = field.genericType;
        if (!isPrimitiveType(genericType)) {
          fieldValue = "$fieldValue.map((e) => e.toEntity()).toList()";
        }
      } else if (!field.primitiveType) {
        fieldValue = "$fieldValue.toEntity()";
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
