import 'package:args/args.dart';

const noFromJson = "no-from-json";
const noToJson = "no-to-json";
const noEntity = "no-entity";
const noFromEntity = "no-from-entity";
const noToEntity = "no-to-entity";
const noCopy = "no-copy";
const input = "input";
const output = "output";
const initialClassName = "init-class";
const prefix = "prefix";
const help = "help";

ArgParser describeArguments() {
  final parser = ArgParser();
  parser
    ..addFlag(help, abbr: 'h', negatable: false, hide: true)
    ..addFlag(noFromJson, negatable: false, help: "Don't generate `fromJson` factory for DTO")
    ..addFlag(noToJson, negatable: false, help: "Don't generate `toJson` method for DTO")
    ..addFlag(
      noEntity,
      negatable: false,
      help: "Don't generate Entity for DTO. "
          "Entity extends `Equatable` and uses `DateTime` instead of `String` with date",
    )
    ..addFlag(noFromEntity, negatable: false, help: "Don't generate `fromEntity` factory for DTO")
    ..addFlag(noToEntity, negatable: false, help: "Don't generate `toEntity` method for DTO")
    ..addFlag(noCopy, negatable: false, help: "Don't generate `CopyWith` annotation")
    ..addOption(input, abbr: "i", help: "Path to the json file")
    ..addOption(output, abbr: "o", help: "Path to the output dart file. Prints to console if not specified")
    ..addOption(
      initialClassName,
      help: "Name of the root model",
      defaultsTo: "Generated",
    )
    ..addOption(
      prefix,
      abbr: "p",
      help: "Prefix for all generated class names",
    );

  return parser;
}
