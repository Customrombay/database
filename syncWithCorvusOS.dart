// Legacy script, needs rewriting to use the addToSupport() and extendedCodenameCreator() functions

import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';
import 'tools/codename_correction.dart'; // Deprecated
import 'tools/android_version_from_crdroid_version.dart';

void main() async {
  File devicesFile = File("filesFromCorvusOS/devices.json");
  String fileContent = devicesFile.readAsStringSync();
  print("OK");
  var yamlWriter = YAMLWriter();
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  List<String> listOfCovered = [];
  YamlMap ydoc = loadYaml(fileContent);
  print(ydoc.runtimeType);
  print(ydoc.entries.length);
  for (var entry in ydoc.entries) {
    print(entry.key);
    String readVendor = entry.key;
    String vendor = "";
    if (readVendor == "Poco") {
      vendor = "Xiaomi";
    }
    else if (readVendor == "Redmi") {
      vendor = "Xiaomi";
    }
    else {
      vendor = readVendor;
    }

    YamlMap devices = entry.value;

    for (var readCodename in devices.keys) {
      if (readCodename == "tulip") {
        continue;
      }
      String codename = codenameCorrection(readCodename, vendor);
      print(codename);
      print(devices[readCodename]["device"]);
      String phoneWebsite = devices[readCodename]["download"] ?? "";
      String state = "Official";
      File thisFile = File("database/phone_data/${vendor.toString().toLowerCase()}-${codename.toString()}.yaml");
      if (await thisFile.exists()) {
        numberOfCovered += 1;
        if (listOfCovered.contains("${vendor.toString().toLowerCase()}-${codename.toString()}")) {
          throw Exception();
        }
        listOfCovered += ["${vendor.toString().toLowerCase()}-${codename.toString()}"];
        String thisFileContent = await thisFile.readAsString();
        var thisFileyaml = loadYaml(thisFileContent);
//       // stdout.write(yamlWriter.write(thisFileyaml));

        List newList = [];
        bool alreadySupported = false;
        for (var thisRom in thisFileyaml["roms"]) {
          String thisRomName = thisRom["rom-name"];
          if (thisRomName == "CorvusOS") {
            alreadySupported = true;
            newList += [
              {
                "rom-name": "CorvusOS",
                "rom-support": true,
                "rom-state": state,
                "android-version": thisRom["android-version"],
                "rom-webpage": "https://www.corvusrom.com/",
                "phone-webpage": phoneWebsite
              }
            ];
          }
          else {
            newList += [thisRom];
          }
        }

        if (!alreadySupported) {
          newList += <dynamic>[
            {
              "rom-name": "CorvusOS",
                "rom-support": true,
                "rom-state": state,
                "android-version": null,
                "rom-webpage": "https://www.corvusrom.com/",
                "phone-webpage": phoneWebsite
            }
          ];
        }

        Map newMap = {
          "device-name" : thisFileyaml["device-name"],
          "device-vendor": thisFileyaml["device-vendor"],
          "device-model-name": thisFileyaml["device-model-name"],
          "device-description": thisFileyaml["device-description"],
          "roms": newList,
          "recoveries": thisFileyaml["recoveries"],
          "linux": thisFileyaml["linux"],
        };

      // File newFile = File("newfiles/${vendor.toString().toLowerCase()}-$codename.yaml");
        await thisFile.writeAsString(yamlWriter.write(newMap));
      }
      else {
        numberOfNotCovered += 1;
        listOfNotCovered += ["${vendor.toString().toLowerCase()}-${codename.toString()}"];
      }
    }
  }
  stdout.write("Covered: $numberOfCovered\n");
  stdout.write("Not covered: $numberOfNotCovered\n");
  for (var deviceNotCovered in listOfNotCovered) {
    stdout.write("$deviceNotCovered\n");
  }
}