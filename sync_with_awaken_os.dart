import 'dart:io';
import 'package:yaml/yaml.dart';

import 'tools/extended_codename_creator.dart';
import 'tools/is_supported.dart';
import 'tools/add_to_support.dart';

void main() async {
  stdout.write("Cloning https://github.com/Project-Awaken/official_devices.git...");
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  // List<String> listOfCovered = [];
  Directory cacheDir = Directory(".cache/AwakenOSSync");
  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }
  cacheDir.createSync(recursive: true);
  Process.runSync("git", ["clone", "-b", "ursa", "https://github.com/Project-Awaken/official_devices.git", cacheDir.path]);
  stdout.write("OK\n");

  for (FileSystemEntity entity in Directory("${cacheDir.path}/devices").listSync()) {
    if (entity is File && entity.path.endsWith(".json")) {
      stdout.write("${entity.path}\n");
      String entityContent = await entity.readAsString();
      YamlMap ydoc = loadYaml(entityContent);
      String readCodename = ydoc["device_display_codename"];
      String deviceName = ydoc["device_display_name"];
      String readVendor = deviceName.split(" ")[0];

      if (readVendor.toLowerCase() == "redmi") {
        readVendor = "xiaomi";
      }

      String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: readVendor);

      bool isActive = ydoc["active"];
      String androidVersion = ydoc["android_version"].toString();

      if (isSupported(extendedCodename: extendedCodename)) {
        numberOfCovered += 1;
        addToSupport(
          androidVersion: androidVersion,
          extendedCodename: extendedCodename,
          romName: "AwakenOS",
          romState: isActive ? "Official" : "Discontinued",
          romSupport: true,
          romNotes: "",
          romWebpage: "https://awakenos.vercel.app/",
          deviceWebpage: "https://awakenos.vercel.app/downloads/$readCodename"
        );
        // listOfCovered += [extendedCodename];
      }
      else {
        numberOfNotCovered += 1;
        listOfNotCovered += [extendedCodename];
      }
    }
  }

  stdout.write("Covered: $numberOfCovered\n");
  stdout.write("Not covered: $numberOfNotCovered\n");
  for (var deviceNotCovered in listOfNotCovered) {
    stdout.write("$deviceNotCovered\n");
  }
}