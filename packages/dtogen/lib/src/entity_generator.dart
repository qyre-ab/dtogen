import 'class_generator.dart';
import 'dto_field.dart';
import 'string_extension.dart';

class EntityGenerator extends ClassGenerator {
  EntityGenerator({
    required super.className,
    required super.generateImports,
    required List<ClassField> fields,
    required this.addCopyWith,
  }) : super(
          fields: fields.map(_mapDtoFieldToEntity).toList(),
        );

  final bool addCopyWith;

  @override
  void generateClass(StringBuffer buffer) {
    if (generateImports) {
      writeImport(buffer, import: "package:equatable/equatable.dart");
      if (addCopyWith) {
        writeImport(buffer,
            import: "package:copy_with_extension/copy_with_extension.dart");
        writeLine(buffer);
        writePart(buffer, import: "${className.camelCaseToSnakeCase()}.g.dart");
      }
      writeLine(buffer);
    }
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
