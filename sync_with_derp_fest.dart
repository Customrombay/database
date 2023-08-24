import 'dart:io';
import 'package:yaml/yaml.dart';

import 'tools/extended_codename_creator.dart';
import 'tools/is_supported.dart';
import 'tools/add_to_support.dart';

void main() async {
  stdout.write("Cloning https://github.com/DerpFest-AOSP/Updater-Stuff.git...");
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  // List<String> listOfCovered = [];
  Directory cacheDir = Directory(".cache/DerpFestSync");
  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }
  cacheDir.createSync(recursive: true);
  Process.runSync("git", ["clone", "-b", "master", "https://github.com/DerpFest-AOSP/Updater-Stuff.git", cacheDir.path]);
  stdout.write("OK\n");
  String codenameFileContent = File("assets/vendor_by_codename.yaml").readAsStringSync();
  YamlList listOfCodenames = loadYaml(codenameFileContent);

  for (FileSystemEntity entity in cacheDir.listSync()) {
    if (entity is File && entity.path.endsWith(".json") && !entity.path.startsWith("changelog_")) {
      stdout.write("${entity.path}\n");
      String entityContent = await entity.readAsString();
      YamlMap ydoc = loadYaml(entityContent);
      YamlMap response = ydoc["response"][0];
      String readCodename = entity.path.split("/").last.replaceAll(".json", "");
      String readVendor = "";
      String androidVersion = response["version"];
      String romType = response["romtype"];
      for (YamlMap codename in listOfCodenames) {
        if (codename["codename"] == readCodename) {
          readVendor = codename["vendors"][0];
        }
      }
      if (readVendor == "") {
        stdout.write("\x1B[33mNo vendor found for $readCodename!\x1B[0m\n");
      }
      else {
        String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: readVendor);
        if (isSupported(extendedCodename: extendedCodename)) {
          numberOfCovered += 1;
          addToSupport(
            androidVersion: androidVersion,
            extendedCodename: extendedCodename,
            romName: "DerpFest",
            romState: romType,
            romSupport: true,
            romWebpage: "https://derpfest.org/",
            deviceWebpage: "https://sourceforge.net/projects/derpfest/files/$readVendor/",
            romNotes: ""
          );
        }
        else {
          numberOfNotCovered += 1;
          listOfNotCovered += [extendedCodename];
        }
      }
    }
  }

  stdout.write("Covered: $numberOfCovered\n");
  stdout.write("Not covered: $numberOfNotCovered\n");
  for (var deviceNotCovered in listOfNotCovered) {
    stdout.write("$deviceNotCovered\n");
  }
}