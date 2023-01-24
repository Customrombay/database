import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';
import 'tools/codename_correction.dart';
import 'tools/android_version_from_lineageos_version.dart';

void main() async {
  var yamlWriter = YAMLWriter();
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  for (var file in await Directory("filesFromHavocOS/twelve/gapps/").list().toList()) {
    String content = await File(file.path).readAsString();
    stdout.write(file.path + "\n");
    var ydoc = loadYaml(content);
    String readVendor = ydoc["oem"];
    String vendor = readVendor;
    if (readVendor.toLowerCase() == "poco") {
      vendor = "Xiaomi";
    }
    String readCodename = ydoc["codename"];
    String codename = codenameCorrection(readCodename, vendor);

    if (File("database/phone_data/${vendor.toLowerCase()}-$codename.yaml").existsSync()) {
      numberOfCovered += 1;
    }
    else {
      numberOfNotCovered += 1;
      listOfNotCovered += ["${vendor.toLowerCase()}-$codename"];
    }

    Map newMap = {
      "device-name" : ["device-name"],
      "device-vendor": ["device-vendor"],
      "device-model-name": ["device-model-name"],
      "device-description": ["device-description"],
      "roms": []
    };

      // File newFile = File("newfiles/${vendor.toString().toLowerCase()}-$codename.yaml");
      // await thisFile.writeAsString(yamlWriter.write(newMap));
  }
  stdout.write("Covered: $numberOfCovered\n");
  stdout.write("Not covered: $numberOfNotCovered\n");
  for (var device in listOfNotCovered) {
    stdout.write("$device\n");
  }

}