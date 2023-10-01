import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

void main() {
  List mainList = [];
  File mainFile = File("database/main.yaml");
  if (mainFile.existsSync()) {
  }
  else {
    mainFile.createSync();
  }
  for (FileSystemEntity entity in Directory("database/phone_data").listSync()) {
    if (entity is File) {
      String content = entity.readAsStringSync();
      YamlMap ydoc = loadYaml(content);
      mainList += [{
        "device-name": ydoc["device-name"],
        "device-vendor": ydoc["device-vendor"],
        "device-model-name": ydoc["device-model-name"]
      }];
      stdout.write("${ydoc["device-vendor"].toString().toLowerCase()}-${ydoc["device-name"]}\n");
    }
  }
  mainList.sort((a, b) => a["device-name"].compareTo(b["device-name"]));
  mainFile.writeAsStringSync(YAMLWriter().write(mainList));
}