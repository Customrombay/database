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
    }
    stdout.write("Covered: $numberOfCovered\n");
    stdout.write("Not covered: $numberOfNotCovered\n");
    for (var deviceNotCovered in listOfNotCovered) {
      stdout.write("$deviceNotCovered\n");
    }
  }
  else {
    throw Exception();
  }
}