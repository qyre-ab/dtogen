import 'package:json_to_dart_entity/dto_generator/class_generator.dart';
import 'package:json_to_dart_entity/dto_generator/dto_class_generator.dart';
import 'package:json_to_dart_entity/dto_generator/dto_field.dart';
import 'package:json_to_dart_entity/dto_generator/entity_generator.dart';
import 'package:json_to_dart_entity/dto_generator/string_extension.dart';

class ModelGenerator {
  ModelGenerator({
    required this.generateFromJson,
    required this.generateToJson,
    required this.generateFromEntity,
    required this.generateToEntity,
    required this.generateEntity,
    required this.generateCopyWith,
    required this.classNamePrefix,
  });

  final bool generateFromJson;
  final bool generateToJson;
  final bool generateFromEntity;
  final bool generateToEntity;

  final bool generateEntity;
  final bool generateCopyWith;

  final String? classNamePrefix;

  String generateModels(Json json, [String? initialClassName]) {
    final classes = _parseClasses(json, initialClassName ?? "Generated");

    final buffer = StringBuffer();
    for (final cl in classes.toList().reversed) {
      buffer.writeln(cl.generate());
    }

    return buffer.toString();
  }

  Set<ClassGenerator> _parseClasses(Json json, String initialClassName) {
    final classes = <ClassGenerator>{};
    _parseClass(
      className: initialClassName,
      json: json,
      generatedClasses: classes,
    );
    return classes;
  }

  ClassGenerator _parseClass({
    required String className,
    required Json json,
    required Set<ClassGenerator> generatedClasses,
  }) {
    final effectiveClassName = _addPrefixWithoutDuplications(className);
    final fields = _parseClassFields(json, generatedClasses);
    final classGenerator = DtoGenerator(
      className: effectiveClassName,
      fields: fields,
      generateFromJson: generateFromJson,
      generateToJson: generateToJson,
      generateFromEntity: generateFromEntity,
      generateToEntity: generateToEntity,
    );
    generatedClasses.add(classGenerator);
    if (generateEntity) {
      generatedClasses.add(
        EntityClassGenerator(
          className: effectiveClassName,
          fields: fields,
          addCopyWith: generateCopyWith,
        ),
      );
    }
    return classGenerator;
  }

  /// Join [classNamePrefix] to [className].
  ///
  /// If [classNamePrefix] ends with the same words as [className] then removes these words.
  /// For example:
  /// ```dart
  /// final classNamePrefix = "UpdateBooking";
  /// ...
  /// final className = _addPrefixWithoutDuplications("BookingPeriod");
  /// print(className); // UpdateBookingPeriod
  /// ```
  String _addPrefixWithoutDuplications(String className) {
    final prefix = classNamePrefix;
    if (prefix == null) return className;

    final prefixParts = prefix.splitByUpperCase();
    for (var i = prefixParts.length - 1; i > 0; i--) {
      final prefixPart = prefixParts.skip(i).join();
      if (className.startsWith(prefixPart)) {
        return "${prefixParts.take(i).join()}$className";
      }
    }

    return "$prefix$className";
  }

  List<ClassField> _parseClassFields(Json json, Set<ClassGenerator> generatedClasses) {
    return json //
        .entries
        .map((entry) => _parseField(entry.key, entry.value, generatedClasses))
        .toList();
  }

  ClassField _parseField(
    String key,
    Object value,
    Set<ClassGenerator> generatedClasses,
  ) {
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
    return ClassField(
      type: fieldType,
      name: _fieldNameFromKey(key),
      value: value,
    );
  }

  String _classNameFromKey(String key) {
    var fieldTypeName = key.split("_").map((e) => e.firstCharToUpperCase()).join();
    if (fieldTypeName.endsWith("s")) {
      fieldTypeName = fieldTypeName.substring(0, fieldTypeName.length - 1);
    }
    return fieldTypeName;
  }

  String _fieldNameFromKey(String key) {
    return key.split("_").map((e) => e.firstCharToUpperCase()).join().firstCharToLowerCase();
  }
}

typedef Json = Map<String, dynamic>;
