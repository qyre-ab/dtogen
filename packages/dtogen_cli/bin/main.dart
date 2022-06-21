import 'dart:convert';
import 'dart:io';

import 'package:dtogen/dtogen.dart';
import 'package:dtogen_cli/args_parser.dart';
import 'package:dtogen_cli/output_generator.dart';

Future<void> main(List<String> arguments) async {
  final argsParser = describeArguments();
  final parsedArgs = argsParser.parse(arguments);

  if (parsedArgs[help] || arguments.isEmpty) {
    print(
      """
A command-line app which is used to generate DTOs and Entities from json.

Usage: dtogen [arguments]

Options:
${argsParser.usage}""",
    );
    return;
  }

  final String? pathToJson = parsedArgs[input];
  if (pathToJson == null) {
    throw Exception("Path to the JSON file must be specified");
  }
  final String initClassName = parsedArgs[initialClassName];
  final generateEntity = !parsedArgs[noEntity];
  final shouldSplitByFiles = parsedArgs[splitByFiles];
  final String? pathToOutput = parsedArgs[output];
  final fileWithJson = File(pathToJson);

  if (!await fileWithJson.exists()) {
    print(fileWithJson.absolute.path);
    print("Given file $pathToJson doesn't exist");
    exit(1);
  } else {
    final jsonString = await fileWithJson.readAsString();
    final json = jsonDecode(jsonString);
    if (json is! Json) {
      print(
          "Json's top-level structure supposed to be a Map but given is ${json.runtimeType}");
      exit(1);
    }
    final modelsGenerator = ModelGenerator(
      generateFromJson: !parsedArgs[noFromJson],
      generateToJson: !parsedArgs[noToJson],
      generateEntity: generateEntity,
      generateFromEntity: !parsedArgs[noFromEntity] && generateEntity,
      generateToEntity: !parsedArgs[noToEntity] && generateEntity,
      generateCopyWith: !parsedArgs[noCopy] && generateEntity,
      classNamePrefix: parsedArgs[prefix],
      generateImports: shouldSplitByFiles,
    );
    final generateResult = modelsGenerator.generate(json, initClassName);
    final outputGenerator = OutputGenerator(
      generatedModelsResult: generateResult,
      splitByFiles: shouldSplitByFiles,
      pathToOutput: pathToOutput,
    );
    outputGenerator.generateOutput();
  }
}
