import 'dart:io';
import 'package:yaml/yaml.dart';

main() async {
  for (var file in await Directory("devices").list().toList()) {
    String content = await File(file.path).readAsString();
    stdout.write("${file.path}\n");
    var ydoc = loadYaml(content);
    var vendor = ydoc["vendor"];
    var name = ydoc["name"];
    var codename = ydoc["codename"];
    var androidVersion = "";
    var lineageOSversion = ydoc["current_branch"];
    var image = ydoc["image"];
    var maintainers = ydoc["maintainers"];
    var state = "";
    var phoneWebpage = "https://wiki.lineageos.org/devices/$codename/";

    if (lineageOSversion.toString() == "19.1") {
      androidVersion = "12L";
      // state = "Official";
    }
    else if (lineageOSversion.toString() == "18.1") {
      androidVersion = "11";
      // state = "Official";
    }
    else if (lineageOSversion.toString() == "17.1") {
      androidVersion = "10";
      // state = "Discontinued";
    }
    else if (lineageOSversion.toString() == "16.0") {
      androidVersion = "9";
      // state = "Discontinued";
    }
    else if (lineageOSversion.toString() == "15.1") {
      androidVersion = "8.1";
      // state = "Discontinued";
    }
    else if (lineageOSversion.toString() == "14.1") {
      androidVersion = "7.1";
      // state = "Discontinued";
    }
    else if (lineageOSversion.toString() == "13.0") {
      androidVersion = "6";
      // state = "Discontinued";
    }
    else if (lineageOSversion.toString() == "12.1") {
      androidVersion = "5.1";
      // state = "Discontinued";
    }
    else if (lineageOSversion.toString() == "12.0") {
      androidVersion = "5.0";
      // state = "Discontinued";
    }
    else if (lineageOSversion.toString() == "11.0") {
      androidVersion = "4.4.4";
      // state = "Discontinued";
    }
    else if (lineageOSversion.toString() == "10.0") {
      androidVersion = "4.1.2";
      // state = "Discontinued";
    }
    else if (lineageOSversion.toString() == "9.0") {
      androidVersion = "4.0.4";
      // state = "Discontinued";
    }
    if (maintainers.length > 0) {
      state = "Official";
    }
    else {
      state = "Discontinued";
    }
    
    String newcontent = """device-name: $codename
device-vendor: $vendor
device-model-name: $name
roms:
  - rom-name: LineageOS
    rom-support: true
    rom-state: $state
    android-version: $androidVersion
    rom-webpage: https://lineageos.org/
    phone-webpage: $phoneWebpage
""";
    String newFilePath = "files/${vendor.toString().toLowerCase()}-$codename.yaml";
    var thisFile = await File(newFilePath).create(recursive: true);
    await thisFile.writeAsString(newcontent);

    Process.run("wget", ["-O", "${vendor.toString().toLowerCase()}-$codename.png", "https://wiki.lineageos.org/images/devices/$image"], workingDirectory: "images");
  }
}