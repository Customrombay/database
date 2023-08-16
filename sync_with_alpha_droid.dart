import 'dart:io';
import 'package:yaml/yaml.dart';

import 'tools/extended_codename_creator.dart';
import 'tools/is_supported.dart';
import 'tools/add_to_support.dart';

void main() async {
  stdout.write("Cloning https://github.com/AlphaDroid-devices/OTA.git...");
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  // List<String> listOfCovered = [];
  Directory cacheDir = Directory(".cache/AlphaDroidOSSync");
  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }
  cacheDir.createSync(recursive: true);
  Process.runSync("git", ["clone", "-b", "alpha-13", "https://github.com/AlphaDroid-devices/OTA.git", cacheDir.path]);
  stdout.write("OK\n");

  for (FileSystemEntity entity in cacheDir.listSync()) {
    if (entity is File && entity.path.endsWith(".json")) {
      stdout.write("${entity.path}\n");
      String entityContent = await entity.readAsString();
      try {
        YamlMap ydoc = loadYaml(entityContent);
        YamlMap response = ydoc["response"][0];
        String readVendor = response["oem"];
        String readCodename = entity.path.split("/").last.replaceAll(".json", "");
        String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: readVendor);

        if (readCodename == "rova") {
          continue;
        }

        if (isSupported(extendedCodename: extendedCodename)) {
          numberOfCovered += 1;
          // listOfCovered += [extendedCodename];
          addToSupport(
            androidVersion: "13",
            extendedCodename: extendedCodename,
            romName: "AlphaDroid",
            romState: "Official",
            romSupport: true,
            romNotes: "",
            romWebpage: "https://sourceforge.net/projects/alphadroid-project/",
            deviceWebpage: "https://sourceforge.net/projects/alphadroid-project/files/$readCodename/"
          );
        }
        else {
          numberOfNotCovered += 1;
          listOfNotCovered += [extendedCodename];
        }
      }
      catch (e) {
        print(e);
      }
    }
  }

  stdout.write("Covered: $numberOfCovered\n");
  stdout.write("Not covered: $numberOfNotCovered\n");
  for (var deviceNotCovered in listOfNotCovered) {
    stdout.write("$deviceNotCovered\n");
  }
}