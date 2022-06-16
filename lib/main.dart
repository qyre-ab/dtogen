import 'dart:convert';
import 'dart:io';

import 'package:json_to_dart_entity/dto_generator/dto_generator.dart';

Future<void> main(List<String> args) async {
  if (args.contains("-h")) {
    print(
      "path-to-file.json "
      "[initialClassName "
      "--no-from-json --no-to-json "
      "--no-entity --no-from-entity --no-to-entity "
      "--no-copy]",
    );
  }
  final pathToJson = args.first;
  String? initialClassName;
  var generateFromJson = !args.contains("--no-from-json");
  var generateToJson = !args.contains("--no-to-json");
  var generateEntity = !args.contains("--no-entity");
  var generateFromEntity = !args.contains("--no-from-entity") && generateEntity;
  var generateToEntity = !args.contains("--no-to-entity") && generateEntity;
  var generateCopyWith = !args.contains("--no-copy") && generateEntity;
  if (args.length > 1) {
    initialClassName = args[1];
  }
  final fileWithJson = File(pathToJson);
  if (!await fileWithJson.exists()) {
    print("Given file $pathToJson doesn't exist");
    exit(1);
  } else {
    final jsonString = await fileWithJson.readAsString();
    final generatedModels = ModelsGenerator(
      generateFromJson: generateFromJson,
      generateToJson: generateToJson,
      generateEntity: generateEntity,
      generateFromEntity: generateFromEntity,
      generateToEntity: generateToEntity,
      generateCopyWith: generateCopyWith,
    ).generateModels(jsonDecode(jsonString), initialClassName);
    print(generatedModels);
  }
}
