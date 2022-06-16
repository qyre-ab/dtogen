import 'dart:convert';
import 'dart:io';

import 'package:json_to_dart_entity/dto_generator/dto_generator.dart';

Future<void> main(List<String> args) async {
  final pathToJson = args.first;
  String? initialClassName;
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
      generateFromJson: true,
      generateToJson: true,
      generateEntity: true,
    ).generateModels(jsonDecode(jsonString), initialClassName);
    print(generatedModels);
  }
}
