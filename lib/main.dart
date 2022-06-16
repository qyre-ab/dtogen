import 'dart:convert';
import 'dart:io';

import 'package:json_to_dart_entity/args_parser.dart';
import 'package:json_to_dart_entity/dto_generator/model_generator.dart';

Future<void> main(List<String> args) async {
  final argsParser = describeArguments();
  final parsedArgs = argsParser.parse(args);

  if (parsedArgs[help]) {
    print(
      """
A command-line app which is used to generate DTOs and Entities from json.

Usage: dtogen [arguments]

Options:
${argsParser.usage}""",
    );
    return;
  }

  final String pathToJson = parsedArgs[input];
  final String initClassName = parsedArgs[initialClassName];
  final generateEntity = !parsedArgs[noEntity];
  final String? pathToOutput = parsedArgs[output];
  final fileWithJson = File(pathToJson);

  if (!await fileWithJson.exists()) {
    print("Given file $pathToJson doesn't exist");
    exit(1);
  } else {
    final jsonString = await fileWithJson.readAsString();
    final json = jsonDecode(jsonString);
    if (json is! Json) {
      print("Json's top-level structure supposed to be a Map but given is ${json.runtimeType}");
      exit(1);
    }
    final generatedModels = ModelGenerator(
      generateFromJson: !parsedArgs[noFromJson],
      generateToJson: !parsedArgs[noToJson],
      generateEntity: generateEntity,
      generateFromEntity: !parsedArgs[noFromEntity] && generateEntity,
      generateToEntity: !parsedArgs[noToEntity] && generateEntity,
      generateCopyWith: !parsedArgs[noCopy] && generateEntity,
      classNamePrefix: parsedArgs[prefix],
    ).generateModels(json, initClassName);

    if (pathToOutput != null) {
      await File(pathToOutput).writeAsString(generatedModels);
    } else {
      print(generatedModels);
    }
  }
}
