import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

void main() async {
  stdout.write("Specify the ROM to remove: ");
  String? romName = stdin.readLineSync();
  int numberOfAffectedFiles = 0;
  if (romName != null) {
    romName = romName.trim();
    if (romName.isNotEmpty) {
      stdout.write("\nRemoving $romName...\n");
      Directory deviceDirectory = Directory("database/phone_data/");
      for (FileSystemEntity entity in deviceDirectory.listSync()) {
        if (entity is File) {
          String fileContent = await entity.readAsString();
          if (fileContent.contains(romName)) {
            YamlMap yamlMap = loadYaml(fileContent);
            Map newMap = {};
            for (String key in yamlMap.keys) {
              newMap[key] = yamlMap[key];
            }
            YamlList listOfRoms = yamlMap["roms"];
            List<YamlMap> newListOfRoms = [];
            for (YamlMap rom in listOfRoms) {
              if (rom["rom-name"] != romName) {
                newListOfRoms += [rom];
              }
              else {
                numberOfAffectedFiles += 1;
              }
            }
            newMap["roms"] = newListOfRoms;
            entity.writeAsString(YAMLWriter().write(newMap));
          }
        }
      }
      stdout.write("Successfully removed $romName from $numberOfAffectedFiles files.\n");
    }
    else {
      stdout.write("\nYou need to specify the ROM. Removed 0 lines.\n");
    }
  }
  else {
    stdout.write("\nYou need to specify the ROM. Removed 0 lines.\n");
  }
}