import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

import 'tools/extended_codename_creator.dart';
import 'tools/is_supported.dart';

void main() async {
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfCovered = [];
  List<String> listOfNotCovered = [];
  List<String> listOfProblematic = [];
  Directory cacheDir = Directory(".cache/TWRPSync");
  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }
  cacheDir.createSync(recursive: true);
  Process.runSync("git", ["clone", "https://github.com/TeamWin/twrpme.git", cacheDir.path]);
  stdout.write("OK\n");
  for (FileSystemEntity entry in cacheDir.listSync().toList()) {
    if (entry is Directory && entry.path.split("/").last.startsWith("_") && !(["_oem", "_app", "_drafts", "_faq", "_terms", "_posts"].contains(entry.path.split("/").last))) {
      for (FileSystemEntity deviceFile in entry.listSync().toList()) {
        if (deviceFile is File && deviceFile.path.endsWith(".markdown")) {
          String content = deviceFile.readAsStringSync();
          String deviceFileName = deviceFile.path.split("/").last;
          String deviceVendorName = deviceFile.path.split("/")[deviceFile.path.split("/").length - 2].replaceFirst("_", "");
          try {
            YamlMap ydoc = loadYaml(content.split("---")[1]);
            String readCodename = ydoc["codename"];
            if (readCodename.contains("/")) {
              List<String> codenameList = readCodename.split("/");
              readCodename = codenameList[0].trim();
            }
            else if (readCodename.contains(",")) {
              List<String> codenameList = readCodename.split(",");
              readCodename = codenameList[0].trim();
            }
            String readVendor = ydoc["oem"];
            String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: readVendor);
            String supportStatus = ydoc["supportstatus"] ?? "Unspecified";
            String deviceWebpage = "https://twrp.me/$deviceVendorName/${deviceFileName.replaceAll(".markdown", ".html")}";
            if (isSupported(extendedCodename: extendedCodename)) {
              if (listOfCovered.contains(extendedCodename)) {
                continue;
              }
              numberOfCovered += 1;
              listOfCovered += [extendedCodename];
              addRecoveryToSupport(
                extendedCodename: extendedCodename,
                recoveryName: "TWRP",
                recoverySupport: true,
                recoveryState: supportStatus,
                recoveryWebpage: "https://twrp.me/",
                deviceWebpage: deviceWebpage
              );
            }
            else {
              numberOfNotCovered += 1;
              listOfNotCovered += [extendedCodename];
            }
            
          } catch (e) {
            listOfProblematic += [deviceFile.path];
          }
        }
      }
    }
  }
  stdout.write("END\n");
  for (String problematicFile in listOfProblematic) {
    stdout.write(problematicFile + "\n");
  }
  stdout.write("Covered: $numberOfCovered\n");
  stdout.write("Not covered: $numberOfNotCovered\n");
  for (var deviceNotCovered in listOfNotCovered) {
    stdout.write("$deviceNotCovered\n");
  }
}

void addRecoveryToSupport({
  required String extendedCodename,
  required String recoveryName,
  required bool recoverySupport,
  required String recoveryState,
  required String recoveryWebpage,
  required String deviceWebpage
}) {
  File deviceFile = File("database/phone_data/$extendedCodename.yaml");
  String thisFileContent = deviceFile.readAsStringSync();
  YamlMap thisFileyaml = loadYaml(thisFileContent);
  List newList = [];
  bool alreadySupported = false;
  if (thisFileyaml.containsKey("recoveries") && thisFileyaml["recoveries"] != null) {
    for (YamlMap thisRecovery in thisFileyaml["recoveries"]) {
      String thisRecoveryName = thisRecovery["recovery-name"];
      if (thisRecoveryName == recoveryName) {
        alreadySupported = true;
        newList += [
          {
            "recovery-name": recoveryName,
            "recovery-support": recoverySupport,
            "recovery-state": recoveryState,
            "recovery-webpage": recoveryWebpage,
            "device-webpage": deviceWebpage
          }
        ];
      }
      else {
        newList += [thisRecovery];
      }
    }

    if (!alreadySupported) {
      newList += <dynamic>[
        {
          "recovery-name": recoveryName,
          "recovery-support": recoverySupport,
          "recovery-state": recoveryState,
          "recovery-webpage": recoveryWebpage,
          "device-webpage": deviceWebpage
        }
      ];
    }
  }
  else {
    newList = [
      {
        "recovery-name": recoveryName,
        "recovery-support": recoverySupport,
        "recovery-state": recoveryState,
        "recovery-webpage": recoveryWebpage,
        "device-webpage": deviceWebpage
      }
    ];
  }

  Map newMap = {
    "device-name" : thisFileyaml["device-name"],
    "device-vendor": thisFileyaml["device-vendor"],
    "device-model-name": thisFileyaml["device-model-name"],
    "device-description": thisFileyaml["device-description"],
    "roms": thisFileyaml["roms"],
    "recoveries": newList
  };

  // File newFile = File("newfiles/${vendor.toString().toLowerCase()}-$codename.yaml");
  deviceFile.writeAsStringSync(YAMLWriter().write(newMap));
}