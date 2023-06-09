import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';
import 'tools/extended_codename_creator.dart';
import 'tools/android_version_from_lineageos_version.dart';

void main() async {
  stdout.write("Cloning https://github.com/LineageOS/lineage_wiki.git...");
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  List<String> listOfCovered = [];
  Directory cacheDir = Directory(".cache/LineageOSSync");
  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }
  cacheDir.createSync(recursive: true);
  Process.runSync("git", ["clone", "https://github.com/LineageOS/lineage_wiki.git", cacheDir.path]);
  stdout.write("OK\n");
  for (FileSystemEntity entry in Directory("${cacheDir.path}/_data/devices").listSync().toList()) {
    print(entry.path);
    if (entry is File) {
      String entryContent = entry.readAsStringSync();
      YamlMap thisydoc = loadYaml(entryContent);
      stdout.write(thisydoc["name"] + "\n");
      if (!listOfCovered.contains(thisydoc["codename"])) {
        List thisList = await updateDeviceFiles(entryContent);
        if (thisList[0]) {
          numberOfCovered += 1;
          listOfCovered += [thisydoc["codename"]];
        }
        else {
          numberOfNotCovered += 1;
          listOfNotCovered += [thisList[1]];
        }
      }
    }
  }
  stdout.write("Covered: $numberOfCovered\n");
  stdout.write("Not covered: $numberOfNotCovered\n");
  for (var device in listOfNotCovered) {
    stdout.write("$device\n");
  }
}

Future<List> updateDeviceFiles(String content) async {
  var ydoc = loadYaml(content);
  var vendor = ydoc["vendor"];
  var name = ydoc["name"];
  var readCodename = ydoc["codename"];

  // String codename = codenameCorrection(readCodename, vendor);
  String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: vendor);

  var androidVersion = "";
  var lineageOSversion = ydoc["current_branch"];
  var image = ydoc["image"];
  var maintainers = ydoc["maintainers"];
  var state = "";
  var phoneWebpage = "https://wiki.lineageos.org/devices/$readCodename/";

  androidVersion = androidVersionFromLineageOSVersion(lineageOSversion.toString());
  if (maintainers.length > 0) {
    state = "Official";
  }
  else {
    state = "Discontinued";
  }

  //stdout.write(vendor + "\n");

  bool thisCovered = false;

  if (await File("database/phone_data/$extendedCodename.yaml").exists()) {
    stdout.write("$extendedCodename \n");
    thisCovered = true;
    //stdout.write(numberOfCovered.toString() + "\n");
  }

  if (thisCovered) {
    File thisFile = File("database/phone_data/$extendedCodename.yaml");
    String thisFileContent = await thisFile.readAsString();
    var thisFileyaml = loadYaml(thisFileContent);

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
      "roms": newList,
      "recoveries": thisFileyaml["recoveries"]
    };

    // File newFile = File("newfiles/${vendor.toString().toLowerCase()}-$codename.yaml");
    await thisFile.writeAsString(YAMLWriter().write(newMap));
  }
  return [thisCovered, extendedCodename];
}