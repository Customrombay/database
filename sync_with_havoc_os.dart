import 'dart:io';
import 'package:yaml/yaml.dart';
import 'tools/add_to_support.dart';
import 'tools/extended_codename_creator.dart';
import 'tools/is_supported.dart';

void main() async {
  stdout.write("Cloning https://github.com/Havoc-OS/OTA.git...");
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  List<String> listOfCovered = [];
  Directory cacheDir = Directory(".cache/HavocOSSync");
  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }
  cacheDir.createSync(recursive: true);
  Process.runSync("git", ["clone", "-b", "thirteen", "https://github.com/Havoc-OS/OTA.git", cacheDir.path]);
  stdout.write("OK\n");
  Directory gappsDir = Directory("${cacheDir.path}/gapps");
  for (FileSystemEntity deviceFile in gappsDir.listSync()){
    if (deviceFile is File) {
      stdout.write("${deviceFile.path}\n");
      String deviceFileContent = await deviceFile.readAsString();
      YamlMap ydoc = loadYaml(deviceFileContent);

      String readVendor = ydoc["oem"];
      String readCodename = ydoc["codename"];
      String romType = ydoc["romtype"];

      String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: readVendor);
      stdout.write("$extendedCodename\n");
      if (romType != "Official") {
        throw Exception();
      }

      if (isSupported(extendedCodename: extendedCodename) && !listOfCovered.contains(extendedCodename)) {
        numberOfCovered += 1;
        listOfCovered += [extendedCodename];
        addToSupport(
          extendedCodename: extendedCodename,
          romName: "HavocOS",
          romState: "Official",
          romSupport: true,
          androidVersion: "13",
          romWebpage: "https://havoc-os.com/",
          deviceWebpage: "https://havoc-os.com/device#$readCodename"
        );
      }
      else if (!listOfNotCovered.contains(extendedCodename) && !listOfCovered.contains(extendedCodename)) {
        numberOfNotCovered += 1;
        listOfNotCovered += [extendedCodename];
      }
    }
  }

  stdout.write("Covered: $numberOfCovered\n");
  stdout.write("Not covered: $numberOfNotCovered\n");
  for (var device in listOfNotCovered) {
    stdout.write("$device\n");
  }
}
