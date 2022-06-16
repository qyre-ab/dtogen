import 'package:json_to_dart_entity/dto_generator/dto_class_generator.dart';
import 'package:json_to_dart_entity/dto_generator/dto_field.dart';

class ModelsGenerator {
  ModelsGenerator({
    required this.generateFromJson,
    required this.generateToJson,
    required this.generateEntity,
  });

  final bool generateFromJson;
  final bool generateToJson;
  final bool generateEntity;

  String generateModels(Json json, [String? initialClassName]) {
    final classes = _parseClasses(json, initialClassName ?? "Generated");

    final buffer = StringBuffer();
    for (final cl in classes) {
      buffer.writeln(cl.generate());
    }

    return buffer.toString();
  }

  Set<DtoClassGenerator> _parseClasses(Json json, String initialClassName) {
    final classes = <DtoClassGenerator>{};
    _parseClass(
      className: initialClassName,
      json: json,
      generatedClasses: classes,
    );
    return classes;
  }

  DtoClassGenerator _parseClass({
    required String className,
    required Json json,
    required Set<DtoClassGenerator> generatedClasses,
  }) {
    final fields = _parseClassFields(json, generatedClasses);
    final classGenerator = DtoClassGenerator(
      className: className,
      fields: fields,
      generateFromJson: generateFromJson,
      generateToJson: generateToJson,
    );
    generatedClasses.add(classGenerator);
    return classGenerator;
  }

  List<DtoField> _parseClassFields(Json json, Set<DtoClassGenerator> generatedClasses) {
    return json //
        .entries
        .map((entry) => _parseField(entry.key, entry.value, generatedClasses))
        .toList();
  }

  DtoField _parseField(String key, Object value, Set<DtoClassGenerator> generatedClasses) {
    final String fieldType;
    if (value is String) {
      fieldType = "String";
    } else if (value is int) {
      fieldType = "int";
    } else if (value is double) {
      fieldType = "double";
    } else if (value is bool) {
      fieldType = "bool";
    } else if (value is Json) {
      fieldType = _parseClass(
        className: _classNameFromKey(key),
        json: value,
        generatedClasses: generatedClasses,
      ).className;
    } else if (value is List) {
      final field = _parseField(key, value.first, generatedClasses);
      fieldType = "List<${field.type}>";
    } else {
      throw Exception(
        "Can't parse json field with because it's value type is not supported.\n"
        "Key: $key, value: $value",
      );
    }
    return DtoField(
      type: fieldType,
      name: _classNameFromKey(key).firstCharToLowerCase(),
    );
  }

  String _classNameFromKey(String key) {
    return key.split("_").map((e) => e.firstCharToUpperCase()).join();
  }
}

typedef Json = Map<String, dynamic>;

extension on String {
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
}
