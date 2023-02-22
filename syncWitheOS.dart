import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';
import 'tools/codename_correction.dart';
import 'tools/android_version_from_letter.dart';

void main() async {
  var yamlWriter = YAMLWriter();
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  int numberOfProblematic = 0;
  List<String> listOfNotCovered = [];
  List listOfProblems = [];
  for (var file in await Directory("filesFromeOS").list().toList()) {
    String content = await File(file.path).readAsString();
    stdout.write(file.path + "\n");
    var ydoc;
    try {
      ydoc = loadYaml(content);
    } on YamlException catch (exception) {
      // ydoc = loadYaml(content);
      numberOfProblematic += 1;
      listOfProblems += [file.path];
      continue;
    }
    var vendor = ydoc["vendor"];
    var name = ydoc["name"];
    var readCodename = ydoc["codename"];
    var build_version_stable = ydoc["build_version_stable"];

    if (build_version_stable == "Pie" || build_version_stable == "pie") {
      build_version_stable = "P";
    }
    else if (build_version_stable == "Oreo" || build_version_stable == "oreo") {
      build_version_stable = "O";
    }

    var build_version_dev = ydoc["build_version_dev"];

    if (build_version_dev == "Nougat") {
      build_version_dev = "N";
    }
    else if (build_version_dev == "Pie" || build_version_dev == "pie") {
      build_version_dev = "P";
    }
    else if (build_version_dev == "Oreo" || build_version_dev == "oreo") {
      build_version_dev = "O";
    }

    var eOSVersion;

    if (build_version_stable != null) {
      eOSVersion = build_version_stable;
    }
    else {
      eOSVersion = build_version_dev;
    }

    String codename = codenameCorrection(readCodename, vendor);

    // var androidVersion = "";
    var lineageOSversion = ydoc["current_branch"];
    // var image = ydoc["image"];
    // var maintainers = ydoc["maintainers"];
    var state = "";
    var phoneWebpage = "https://doc.e.foundation/devices/$readCodename";

    var androidVersion = androidVersionFromLetter(eOSVersion);

    // androidVersion = androidVersionFromLineageOSVersion(lineageOSversion.toString());
    // try {
    //   if (maintainers.length > 0) {
    //     state = "Official";
    //   }
    //   else {
    //     state = "Discontinued";
    //   }
    // } on NoSuchMethodError catch (e) {
    //   state = "Discontinued";
    // }

    var legacy = ydoc["legacy"];
    if (legacy == null) {
      state = "Official";
    }
    else {
      if (legacy == "yes") {
        state = "Discontinued";
      }
      else {
        throw Exception();
      }
    }

    //stdout.write(vendor + "\n");

    bool thisCovered = false;
    File thisFile = File("database/phone_data/${vendor.toString().toLowerCase()}-$codename.yaml");

    if (await thisFile.exists()) {
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
      // File thisFile = File("database/phone_data/${vendor.toString().toLowerCase()}-$codename.yaml");
      String thisFileContent = await thisFile.readAsString();
      var thisFileyaml = loadYaml(thisFileContent);
      List newList = [];
      bool alreadySupported = false;
      for (var thisRom in thisFileyaml["roms"]) {
        String thisRomName = thisRom["rom-name"];
        if (thisRomName == "/e/OS") {
          alreadySupported = true;
          newList += [
            {
              "rom-name": "/e/OS",
              "rom-support": true,
              "rom-state": state,
              "android-version": androidVersion,
              "rom-webpage": "https://e.foundation/e-os/",
              "phone-webpage": phoneWebpage
            }
          ];
        }
        else {
          newList += [thisRom];
        }
      }

      if (!alreadySupported) {
        newList += [
          {
            "rom-name": "/e/OS",
            "rom-support": true,
            "rom-state": state,
            "android-version": androidVersion,
            "rom-webpage": "https://e.foundation/e-os/",
            "phone-webpage": phoneWebpage
          }
        ];
      }

      Map newMap = {
        "device-name" : thisFileyaml["device-name"],
        "device-vendor": thisFileyaml["device-vendor"],
        "device-model-name": thisFileyaml["device-model-name"],
        "device-description": thisFileyaml["device-description"],
        "roms": newList,
        "recoveries": thisFileyaml["recoveries"]
      };

      // File newFile = File("newfiles/${vendor.toString().toLowerCase()}-$codename.yaml");
      await thisFile.writeAsString(yamlWriter.write(newMap));
    }
  }
  stdout.write("Covered: $numberOfCovered\n");
  stdout.write("Not covered: $numberOfNotCovered\n");
  stdout.write("Problematic: $numberOfProblematic\n");
  for (var device in listOfNotCovered) {
    stdout.write("$device\n");
  }
  for (var ok in listOfProblems) {
    stdout.write("$ok\n");
  }

}