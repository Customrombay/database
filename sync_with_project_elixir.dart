import 'dart:io';
import 'package:yaml/yaml.dart';

import 'tools/extended_codename_creator.dart';
import 'tools/is_supported.dart';
import 'tools/add_to_support.dart';

void main() async {
  stdout.write("Cloning https://github.com/ProjectElixir-Devices/official_devices.git...");
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  // List<String> listOfCovered = [];
  Directory cacheDir = Directory(".cache/ProjectElixirSync");
  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }
  cacheDir.createSync(recursive: true);
  Process.runSync("git", ["clone", "-b", "A13", "https://github.com/ProjectElixir-Devices/official_devices.git", cacheDir.path]);
  stdout.write("OK\n");

  for (FileSystemEntity entity in Directory("${cacheDir.path}/builds").listSync()) {
    if (entity is File && entity.path.endsWith(".json")) {
      stdout.write("${entity.path}\n");
      String entityContent = await entity.readAsString();
      try {
        YamlMap ydoc = loadYaml(entityContent);
        String deviceName = ydoc["device_name"];
        String readVendor = ["redmi", "poco"].contains(deviceName.split(" ")[0].toLowerCase()) ? "xiaomi" : deviceName.split(" ")[0];
        if (readVendor.toLowerCase() == "galaxy") {
          readVendor = "samsung";
        }
        String readCodename = ydoc["device"];
        bool isActive = ydoc["is_active"];
        String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: readVendor);

        if (isSupported(extendedCodename: extendedCodename)) {
          numberOfCovered += 1;
          addToSupport(
            androidVersion: "13",
            extendedCodename: extendedCodename,
            romName: "Project Elixir",
            romState: isActive ? "Official" : "Discontinued",
            romSupport: true,
            romNotes: "",
            romWebpage: "https://projectelixiros.com/home",
            deviceWebpage: "https://projectelixiros.com/device/$readCodename"
          );
          // listOfCovered += [extendedCodename];
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