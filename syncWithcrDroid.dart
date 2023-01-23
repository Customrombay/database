import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';
import 'tools/codename_correction.dart';
import 'tools/android_version_from_crdroid_version.dart';

void main() async {
  var response = await http.get(Uri.parse("https://crdroid.net/devices_handler/compiled.json"));
  if (response.statusCode == 200) {
    print("OK");
    var yamlWriter = YAMLWriter();
    int numberOfCovered = 0;
    int numberOfNotCovered = 0;
    List<String> listOfNotCovered = [];
    List<String> listOfCovered = [];
    YamlMap ydoc = loadYaml(response.body);
    print(ydoc.runtimeType);
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
        if (readCodename == "z2_plus" && readVendor == "Lenovo") {
          vendor = "ZUK";
        }
        String codename = codenameCorrection(readCodename, vendor);
        print(codename);
        int newestVersion = 0;
        YamlMap versions = devices[readCodename];
        bool isMaintained = false;
        for (var version in versions.keys) {
          print(version);
          int thisVersion = int.parse(version.toString());
          if (thisVersion > newestVersion) {
            newestVersion = thisVersion;
          }
          YamlMap finals = versions[version];
          String deviceName = finals["device"];
          String maintainers = finals["maintainer"];
          if (maintainers != "") {
            isMaintained = true;
          }
        }
        String state = isMaintained ? "Official" : "Discontinued";
        String phoneWebpage = "https://crdroid.net/downloads#$readCodename";
        print(newestVersion);
        String androidVersion = androidVersionFromCrDroidVersion(newestVersion.toString());
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
            if (thisRomName == "crDroid") {
              alreadySupported = true;
              newList += [
                {
                  "rom-name": "crDroid",
                  "rom-support": true,
                  "rom-state": state,
                  "android-version": androidVersion,
                  "rom-webpage": "https://crdroid.net/",
                  "phone-webpage": phoneWebpage
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
                "rom-name": "crDroid",
                  "rom-support": true,
                  "rom-state": state,
                  "android-version": androidVersion,
                  "rom-webpage": "https://crdroid.net/",
                  "phone-webpage": phoneWebpage
              }
            ];
          }

          Map newMap = {
            "device-name" : thisFileyaml["device-name"],
            "device-vendor": thisFileyaml["device-vendor"],
            "device-model-name": thisFileyaml["device-model-name"],
            "device-description": thisFileyaml["device-description"],
            "roms": newList
          };

//       // File newFile = File("newfiles/${vendor.toString().toLowerCase()}-$codename.yaml");
          await thisFile.writeAsString(yamlWriter.write(newMap));
        }
        else {
          numberOfNotCovered += 1;
          listOfNotCovered += ["${vendor.toString().toLowerCase()}-${codename.toString()}"];
        }
        if (readCodename == "z2_plus" && readVendor == "Lenovo") {
          vendor = "Lenovo";
        }
      }
      stdout.write("Covered: $numberOfCovered\n");
      stdout.write("Not covered: $numberOfNotCovered\n");
      for (var deviceNotCovered in listOfNotCovered) {
        stdout.write("$deviceNotCovered\n");
      }
    }
//   for (var file in await Directory("filesFromLineageOS/devices").list().toList()) {
//     String content = await File(file.path).readAsString();
//     stdout.write(file.path + "\n");
//     var ydoc = loadYaml(content);
//     var vendor = ydoc["vendor"];
//     var name = ydoc["name"];
//     var readCodename = ydoc["codename"];

//     String codename = "";
//     if (readCodename == "twolip" && vendor == "Xiaomi") {
//       codename = "tulip";
//     }
//     else if (readCodename == "apollon" && vendor == "Xiaomi") {
//       codename = "apollo";
//     }
//     else {
//       codename = readCodename;
//     }

//     var androidVersion = "";
//     var lineageOSversion = ydoc["current_branch"];
//     var image = ydoc["image"];
//     var maintainers = ydoc["maintainers"];
//     var state = "";
//     var phoneWebpage = "https://wiki.lineageos.org/devices/$codename/";

//     if (lineageOSversion.toString() == "20") {
//       androidVersion = "13";
//       // state = "Official";
//     }
//     else if (lineageOSversion.toString() == "19.1") {
//       androidVersion = "12L";
//       // state = "Official";
//     }
//     else if (lineageOSversion.toString() == "18.1") {
//       androidVersion = "11";
//       // state = "Official";
//     }
//     else if (lineageOSversion.toString() == "17.1") {
//       androidVersion = "10";
//       // state = "Discontinued";
//     }
//     else if (lineageOSversion.toString() == "16.0") {
//       androidVersion = "9";
//       // state = "Discontinued";
//     }
//     else if (lineageOSversion.toString() == "15.1") {
//       androidVersion = "8.1";
//       // state = "Discontinued";
//     }
//     else if (lineageOSversion.toString() == "14.1") {
//       androidVersion = "7.1";
//       // state = "Discontinued";
//     }
//     else if (lineageOSversion.toString() == "13.0") {
//       androidVersion = "6";
//       // state = "Discontinued";
//     }
//     else if (lineageOSversion.toString() == "12.1") {
//       androidVersion = "5.1";
//       // state = "Discontinued";
//     }
//     else if (lineageOSversion.toString() == "12.0") {
//       androidVersion = "5.0";
//       // state = "Discontinued";
//     }
//     else if (lineageOSversion.toString() == "11.0") {
//       androidVersion = "4.4.4";
//       // state = "Discontinued";
//     }
//     else if (lineageOSversion.toString() == "10.0") {
//       androidVersion = "4.1.2";
//       // state = "Discontinued";
//     }
//     else if (lineageOSversion.toString() == "9.0") {
//       androidVersion = "4.0.4";
//       // state = "Discontinued";
//     }
//     if (maintainers.length > 0) {
//       state = "Official";
//     }
//     else {
//       state = "Discontinued";
//     }

//     //stdout.write(vendor + "\n");

//     bool thisCovered = false;

//     if (await File("database/phone_data/${vendor.toString().toLowerCase()}-$codename.yaml").exists()) {
//       stdout.write("${vendor.toString().toLowerCase()}-$codename \n");
//       numberOfCovered += 1;
//       thisCovered = true;
//       //stdout.write(numberOfCovered.toString() + "\n");
//     }
//     else {
//       numberOfNotCovered += 1;
//       listOfNotCovered += ["$vendor-$codename"];
//     }

//     if (thisCovered) {
//       File thisFile = File("database/phone_data/${vendor.toString().toLowerCase()}-$codename.yaml");
//       String thisFileContent = await thisFile.readAsString();
//       var thisFileyaml = loadYaml(thisFileContent);
//       // stdout.write(yamlWriter.write(thisFileyaml));

//       //Map thisMap = Map.from(thisFileyaml);
//       //thisMap["roms"] = List.from(thisMap["roms"]);
//       //stdout.write(androidVersion);

//       // for (var thisRom in thisMap["roms"]) {
//       //   thisRom = Map.from(thisRom);
//       //   // stdout.write("${thisRom.runtimeType}\n");
//       //   String thisRomName = thisRom["rom-name"];
//       //   if (thisRomName == "LineageOS") {
//       //     thisRom["rom-support"] = true;
//       //     thisRom["rom-state"] = state;
//       //     thisRom["android-version"] = androidVersion;
//       //     thisRom["rom-webpage"] = "https://lineageos.org/";
//       //     thisRom["phone-webpage"] = phoneWebpage;
//       //   }
//       // }

//       // stdout.write(thisMap);

//       List newList = [];
//       bool alreadySupported = false;
//       for (var thisRom in thisFileyaml["roms"]) {
//         String thisRomName = thisRom["rom-name"];
//         if (thisRomName == "LineageOS") {
//           alreadySupported = true;
//           newList += [
//             {
//               "rom-name": "LineageOS",
//               "rom-support": true,
//               "rom-state": state,
//               "android-version": androidVersion,
//               "rom-webpage": "https://lineageos.org/",
//               "phone-webpage": phoneWebpage
//             }
//           ];
//         }
//         else {
//           newList += [thisRom];
//         }
//       }

//       if (!alreadySupported) {
//         newList = <dynamic>[
//           {
//             "rom-name": "LineageOS",
//             "rom-support": true,
//             "rom-state": state,
//             "android-version": androidVersion,
//             "rom-webpage": "https://lineageos.org/",
//             "phone-webpage": phoneWebpage
//           }
//         ] + newList;
//       }

//       Map newMap = {
//         "device-name" : thisFileyaml["device-name"],
//         "device-vendor": thisFileyaml["device-vendor"],
//         "device-model-name": thisFileyaml["device-model-name"],
//         "device-description": thisFileyaml["device-description"],
//         "roms": newList
//       };

//       // File newFile = File("newfiles/${vendor.toString().toLowerCase()}-$codename.yaml");
//       await thisFile.writeAsString(yamlWriter.write(newMap));
//     }
//   }
//   stdout.write("Covered: $numberOfCovered\n");
//   stdout.write("Not covered: $numberOfNotCovered\n");
//   for (var device in listOfNotCovered) {
//     stdout.write("$device\n");
//   }
  }
  else {
    throw Exception();
  }
}