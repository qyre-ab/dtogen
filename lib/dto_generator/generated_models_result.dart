import 'package:dtogen/dto_generator/dto_class_generator.dart';
import 'package:dtogen/dto_generator/entity_generator.dart';

class GeneratedModelsResult {
  const GeneratedModelsResult({
    required this.dtoGenerators,
    required this.entityGenerators,
  });

  final List<DtoGenerator> dtoGenerators;
  final List<EntityGenerator> entityGenerators;

  String writeClassesToString() {
    final buffer = StringBuffer();
    for (final classGenerator in [...entityGenerators.reversed, ...dtoGenerators.reversed]) {
      buffer.writeln(classGenerator.generate());
    }

    return buffer.toString();
  }
}
