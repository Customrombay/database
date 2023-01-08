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
  for (var file in await Directory("filesFromLineageOS/devices").list().toList()) {
    String content = await File(file.path).readAsString();
    stdout.write(file.path + "\n");
    var ydoc = loadYaml(content);
    var vendor = ydoc["vendor"];
    var name = ydoc["name"];
    var readCodename = ydoc["codename"];

    String codename = codenameCorrection(readCodename, vendor);

    var androidVersion = "";
    var lineageOSversion = ydoc["current_branch"];
    var image = ydoc["image"];
    var maintainers = ydoc["maintainers"];
    var state = "";
    var phoneWebpage = "https://wiki.lineageos.org/devices/$codename/";

    androidVersion = androidVersionFromLineageOSVersion(lineageOSversion.toString());
    if (maintainers.length > 0) {
      state = "Official";
    }
    else {
      state = "Discontinued";
    }

    //stdout.write(vendor + "\n");

    bool thisCovered = false;

    if (await File("database/phone_data/${vendor.toString().toLowerCase()}-$codename.yaml").exists()) {
      stdout.write("${vendor.toString().toLowerCase()}-$codename \n");
      numberOfCovered += 1;
      thisCovered = true;
      //stdout.write(numberOfCovered.toString() + "\n");
    }
    else {
      numberOfNotCovered += 1;
      listOfNotCovered += ["$vendor-$codename"];
    }

    if (thisCovered) {
      File thisFile = File("database/phone_data/${vendor.toString().toLowerCase()}-$codename.yaml");
      String thisFileContent = await thisFile.readAsString();
      var thisFileyaml = loadYaml(thisFileContent);
      // stdout.write(yamlWriter.write(thisFileyaml));

      //Map thisMap = Map.from(thisFileyaml);
      //thisMap["roms"] = List.from(thisMap["roms"]);
      //stdout.write(androidVersion);

      // for (var thisRom in thisMap["roms"]) {
      //   thisRom = Map.from(thisRom);
      //   // stdout.write("${thisRom.runtimeType}\n");
      //   String thisRomName = thisRom["rom-name"];
      //   if (thisRomName == "LineageOS") {
      //     thisRom["rom-support"] = true;
      //     thisRom["rom-state"] = state;
      //     thisRom["android-version"] = androidVersion;
      //     thisRom["rom-webpage"] = "https://lineageos.org/";
      //     thisRom["phone-webpage"] = phoneWebpage;
      //   }
      // }

      // stdout.write(thisMap);

      List newList = [];
      bool alreadySupported = false;
      for (var thisRom in thisFileyaml["roms"]) {
        String thisRomName = thisRom["rom-name"];
        if (thisRomName == "LineageOS") {
          alreadySupported = true;
          newList += [
            {
              "rom-name": "LineageOS",
              "rom-support": true,
              "rom-state": state,
              "android-version": androidVersion,
              "rom-webpage": "https://lineageos.org/",
              "phone-webpage": phoneWebpage
            }
          ];
        }
        else {
          newList += [thisRom];
        }
      }

      if (!alreadySupported) {
        newList = <dynamic>[
          {
            "rom-name": "LineageOS",
            "rom-support": true,
            "rom-state": state,
            "android-version": androidVersion,
            "rom-webpage": "https://lineageos.org/",
            "phone-webpage": phoneWebpage
          }
        ] + newList;
      }

      Map newMap = {
        "device-name" : thisFileyaml["device-name"],
        "device-vendor": thisFileyaml["device-vendor"],
        "device-model-name": thisFileyaml["device-model-name"],
        "device-description": thisFileyaml["device-description"],
        "roms": newList
      };

      // File newFile = File("newfiles/${vendor.toString().toLowerCase()}-$codename.yaml");
      await thisFile.writeAsString(yamlWriter.write(newMap));
    }
  }
  stdout.write("Covered: $numberOfCovered\n");
  stdout.write("Not covered: $numberOfNotCovered\n");
  for (var device in listOfNotCovered) {
    stdout.write("$device\n");
  }

}