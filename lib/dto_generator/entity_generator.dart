import 'package:json_to_dart_entity/dto_generator/class_generator.dart';
import 'package:json_to_dart_entity/dto_generator/dto_field.dart';
import 'package:json_to_dart_entity/dto_generator/string_extension.dart';

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
