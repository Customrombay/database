import 'dart:convert';
import 'dart:io';
import 'package:yaml/yaml.dart';

import 'tools/extended_codename_creator.dart';
import 'tools/is_supported.dart';
import 'tools/add_to_support.dart';

void main() async {
  stdout.write("Cloning https://github.com/RisingOSS-devices/android_vendor_RisingOTA.git...");
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  // List<String> listOfCovered = [];
  Directory cacheDir = Directory(".cache/RisingOSSync");
  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }
  cacheDir.createSync(recursive: true);
  Process.runSync("git", ["clone", "-b", "thirteen", "https://github.com/RisingOSS-devices/android_vendor_RisingOTA.git", cacheDir.path]);
  stdout.write("OK\n");

  for (FileSystemEntity entity in cacheDir.listSync()) {
    if (entity is File && entity.path.endsWith(".json")) {
      stdout.write("${entity.path}\n");
      String entityContent = await entity.readAsString(encoding: Encoding.getByName("ISO_8859-1:1987")!);
      try {
        YamlMap ydoc = loadYaml(entityContent);
        YamlMap response = ydoc["response"][0];
        String readVendor = response["oem"];
        if (readVendor.toLowerCase() == "xioami" || readVendor.toLowerCase() == "mi" || readVendor.toLowerCase() == "oem") {
          readVendor = "xiaomi";
        }
        String readCodename = entity.path.split("/").last.replaceAll(".json", "");
        String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: readVendor);

        if (isSupported(extendedCodename: extendedCodename)) {
          numberOfCovered += 1;
          // listOfCovered += [extendedCodename];
         addToSupport(
            androidVersion: "13",
            extendedCodename: extendedCodename,
            romName: "RisingOS",
            romState: "Official",
            romSupport: true,
            romNotes: "",
            romWebpage: "https://github.com/RisingTechOSS/android",
            deviceWebpage: response["download"]
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