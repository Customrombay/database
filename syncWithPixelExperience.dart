import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';
import 'tools/extended_codename_creator.dart';
import 'tools/android_version_from_pixel_experience_version.dart';

void main() async {
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  http.Response response = await http.get(Uri.parse("https://raw.githubusercontent.com/PixelExperience/official_devices/master/devices.json"));
  if (response.statusCode == 200) {
    String content = response.body;
    YamlList ydoc = loadYaml(content);
    for (YamlMap device in ydoc) {
      String readName = device["name"];
      String readBrand = device["brand"];
      String readCodename = device["codename"];
      YamlList readSupportedVersions = device["supported_versions"];

      String extendedCodename = extendedCodenameCreator(readCodename: readCodename, vendor: readBrand);
      stdout.write("$extendedCodename\n");

      int maxRegularVersion = 0;
      int maxPlusVersion = 0;
      String regularState = "";
      String plusState = "";

      for (YamlMap version in readSupportedVersions) {
        String readVersionCode = version["version_code"];
        bool isStable = version["stable"] ?? true;
        bool isDeprecated = version["deprecated"];
        if (readVersionCode.endsWith("plus")) {
          int thisPlusVersion = androidVersionFromPixelExperienceVersion(pixelExperienceVersion: readVersionCode);
          if (thisPlusVersion > maxPlusVersion) {
            maxPlusVersion = thisPlusVersion;
            plusState = pixelExperienceState(isStable: isStable, isDeprecated: isDeprecated);
          }
        }
        else {
          int thisRegularVersion = androidVersionFromPixelExperienceVersion(pixelExperienceVersion: readVersionCode);
          if (thisRegularVersion > maxRegularVersion) {
            maxRegularVersion = thisRegularVersion;
            regularState = pixelExperienceState(isStable: isStable, isDeprecated: isDeprecated);
          }
        }
      }

      if (isSupported(extendedCodename: extendedCodename)) {
        numberOfCovered += 1;
        addToSupport(
          androidVersion: maxRegularVersion.toString(),
          extendedCodename: extendedCodename,
          romName: "PixelExperience",
          romState: regularState,
          romSupport: true,
          romWebpage: "https://download.pixelexperience.org/",
          deviceWebpage: "https://download.pixelexperience.org/$readCodename/"
        );
        if (maxPlusVersion > 0) {
          addToSupport(
            androidVersion: maxPlusVersion.toString(),
            extendedCodename: extendedCodename,
            romName: "PixelExperience Plus",
            romState: plusState,
            romSupport: true,
            romWebpage: "https://download.pixelexperience.org/",
            deviceWebpage: "https://download.pixelexperience.org/$readCodename/"
          );
        }
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

bool isSupported({
  required String extendedCodename
}) {
  if (File("database/phone_data/$extendedCodename.yaml").existsSync()) {
    return true;
  }
  return false;
}

String pixelExperienceState({
  required bool isStable,
  required bool isDeprecated
}) {
  if (isDeprecated) {
    return "Discontinued";
  }
  else if (isStable) {
    return "Official";
  }
  else {
    return "Beta";
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