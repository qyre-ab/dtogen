import 'package:meta/meta.dart';

import 'dto_field.dart';

abstract class ClassGenerator {
  const ClassGenerator({
    required this.className,
    required this.fields,
    required this.generateImports,
  });

  final String className;
  final List<ClassField> fields;

  final bool generateImports;

  String generate() {
    final buffer = StringBuffer();
    generateClass(buffer);
    return buffer.toString();
  }

  void generateClass(StringBuffer buffer);

  void writeImport(StringBuffer buffer, {required String import}) {
    buffer.writeln("import '$import';");
  }

  @protected
  void writePart(StringBuffer buffer, {required String import}) {
    buffer.writeln("part '$import';");
  }

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
