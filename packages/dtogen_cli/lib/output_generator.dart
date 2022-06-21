import 'dart:io';

import 'package:dtogen/dtogen.dart';
import 'package:path/path.dart';

class OutputGenerator {
  const OutputGenerator({
    required this.generatedModelsResult,
    required this.pathToOutput,
    required this.splitByFiles,
  });

  final GeneratedModelsResult generatedModelsResult;
  final String? pathToOutput;
  final bool splitByFiles;

  Future<void> generateOutput() async {
    final pathToOutput = this.pathToOutput;
    if (!splitByFiles) {
      final generatedClasses = generatedModelsResult.writeClassesToString();

      if (pathToOutput != null) {
        await File(pathToOutput).writeAsString(generatedClasses);
      } else {
        print(generatedClasses);
      }
    } else {
      final outputPath = join(Directory.current.path, pathToOutput ?? "output");

      await _writeClassesToDirectory(
        directoryPath: join(outputPath, "dtos"),
        classGenerators: generatedModelsResult.dtoGenerators,
      );
      await _writeClassesToDirectory(
        directoryPath: join(outputPath, "entities"),
        classGenerators: generatedModelsResult.entityGenerators,
      );
    }
  }

  Future<void> _writeClassesToDirectory({
    required String directoryPath,
    required List<ClassGenerator> classGenerators,
  }) async {
    await Directory(directoryPath).create(recursive: true);
    for (final classGenerator in classGenerators) {
      final outputFile = File(
        join(
          directoryPath,
          "${classGenerator.className.camelCaseToSnakeCase()}.dart",
        ),
      );
      await outputFile.writeAsString(classGenerator.generate());
    }
  }
}
