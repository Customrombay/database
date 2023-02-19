import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';
import 'tools/extended_codename_creator.dart';
import 'tools/android_version_from_number_name.dart';
import 'tools/is_supported.dart';

void main() async {
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  var response = await http.get(Uri.parse("https://raw.githubusercontent.com/PixysOS/official_devices/master/devices.json"));
  if (response.statusCode == 200) {
    stdout.write("OK\n");
    YamlList listOfDevices = loadYaml(response.body);
    for (YamlMap device in listOfDevices) {
      String readCodename = device["codename"];
      String readVendor = device["brand"];
      String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: readVendor);
      YamlList listOfSupportedVersions = device["supported_bases"];
      int maxAndroidVersion = 0;
      for (YamlMap version in listOfSupportedVersions) {
        String name = version["name"];
        int androidVersion = androidVersionFromNumberName(androidVersionNumberName: name);
        if (maxAndroidVersion < androidVersion) {
          maxAndroidVersion = androidVersion;
        }
      }
      if (isSupported(extendedCodename: extendedCodename)) {
        numberOfCovered += 1;
        addToSupport(
          androidVersion: maxAndroidVersion.toString(),
          extendedCodename: extendedCodename,
          romName: "PixysOS",
          romState: "Official",
          romSupport: true,
          romWebpage: "https://pixysos.com/",
          deviceWebpage: "https://pixysos.com/$readCodename"
        );
      }
      else {
        numberOfNotCovered += 1;
        listOfNotCovered += [extendedCodename];
      }

    }
    
    stdout.write("Covered: $numberOfCovered\n");
    stdout.write("Not covered: $numberOfNotCovered\n");
    for (var deviceNotCovered in listOfNotCovered) {
      stdout.write("$deviceNotCovered\n");
    }
  }
}

void addToSupport({String androidVersion = "", String extendedCodename = "", String romName = "", String romState = "", bool romSupport = false, String romWebpage = "", String deviceWebpage = ""}) async {
  File deviceFile = File("database/phone_data/$extendedCodename.yaml");
  String thisFileContent = await deviceFile.readAsString();
  var thisFileyaml = loadYaml(thisFileContent);
  List newList = [];
  bool alreadySupported = false;
  for (var thisRom in thisFileyaml["roms"]) {
    String thisRomName = thisRom["rom-name"];
    if (thisRomName == romName) {
      alreadySupported = true;
      newList += [
        {
          "rom-name": romName,
          "rom-support": romSupport,
          "rom-state": romState,
          "android-version": androidVersion,
          "rom-webpage": romWebpage,
          "phone-webpage": deviceWebpage
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
        "rom-name": romName,
        "rom-support": romSupport,
        "rom-state": romState,
        "android-version": androidVersion,
        "rom-webpage": romWebpage,
        "phone-webpage": deviceWebpage
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

  // File newFile = File("newfiles/${vendor.toString().toLowerCase()}-$codename.yaml");
  await deviceFile.writeAsString(YAMLWriter().write(newMap));
}
