import 'dart:io';
import 'package:yaml/yaml.dart';

import 'tools/extended_codename_creator.dart';
import 'tools/is_supported.dart';
import 'tools/add_linux_to_support.dart';

void main() async {
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfCovered = [];
  List<String> listOfNotCovered = [];
  Directory cacheDir = Directory(".cache/UbuntuTouchSync");
  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }
  cacheDir.createSync(recursive: true);
  Process.runSync("git", ["clone", "https://gitlab.com/ubports/infrastructure/devices.ubuntu-touch.io.git", cacheDir.path]);
  stdout.write("OK\n");

  for (FileSystemEntity entry in Directory("${cacheDir.path}/data/devices").listSync().toList()) {
    print(entry.path);
    if(entry is Directory) {
      String readCodename = entry.path.split("/").last;
      print(readCodename);
      File dataFile = File("${entry.path}/data.md");
      String dataFileContent = await dataFile.readAsString();
      YamlMap ydoc = loadYaml(dataFileContent.split("---")[1]);
      String deviceName = ydoc["name"] ?? "NoName";
      print(deviceName);
      String readVendor = deviceName.split(" ")[0];
      String extendedCodename = extendedCodenameCreator(
        readCodename: readCodename,
        readVendor: readVendor
      );
      if (isSupported(extendedCodename: extendedCodename)) {
        numberOfCovered += 1;
        listOfCovered += [extendedCodename];
        addLinuxToSupport(
          extendedCodename: extendedCodename,
          distributionName: "Ubuntu Touch",
          distributionSupport: true,
          distributionState: "Official",
          distributionWebpage: "https://ubuntu-touch.io/",
          deviceWebpage: "https://devices.ubuntu-touch.io/device/$readCodename"
        );
      }
      else {
        numberOfNotCovered += 1;
        listOfNotCovered += [extendedCodename];
      }
    }
  }

  stdout.write("END\n");
  stdout.write("Covered: $numberOfCovered\n");
  stdout.write("Not covered: $numberOfNotCovered\n");
  for (var deviceNotCovered in listOfNotCovered) {
    stdout.write("$deviceNotCovered\n");
  }
}