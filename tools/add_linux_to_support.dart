import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

void addLinuxToSupport({
  required String extendedCodename,
  required String distributionName,
  required bool distributionSupport,
  required String distributionState,
  required String distributionWebpage,
  required String deviceWebpage,
  String? distributionNotes
}) {
  File deviceFile = File("database/phone_data/$extendedCodename.yaml");
  String thisFileContent = deviceFile.readAsStringSync();
  YamlMap thisFileyaml = loadYaml(thisFileContent);
  List newList = [];
  bool alreadySupported = false;
  if (thisFileyaml.containsKey("linux") && thisFileyaml["linux"] != null) {
    for (YamlMap thisDistribution in thisFileyaml["linux"]) {
      String thisDistributionName = thisDistribution["distribution-name"];
      if (thisDistributionName == distributionName) {
        alreadySupported = true;
        newList += [
          {
            "distribution-name": distributionName,
            "distribution-support": distributionSupport,
            "distribution-state": distributionState,
            "distribution-notes": distributionNotes,
            "distribution-webpage": distributionWebpage,
            "device-webpage": deviceWebpage
          }
        ];
      }
      else {
        newList += [thisDistribution];
      }
    }

    if (!alreadySupported) {
      newList += <dynamic>[
        {
          "distribution-name": distributionName,
          "distribution-support": distributionSupport,
          "distribution-state": distributionState,
          "distribution-notes": distributionNotes,
          "distribution-webpage": distributionWebpage,
          "device-webpage": deviceWebpage
        }
      ];
    }
  }
  else {
    newList = [
      {
        "distribution-name": distributionName,
        "distribution-support": distributionSupport,
        "distribution-state": distributionState,
        "distribution-notes": distributionNotes,
        "distribution-webpage": distributionWebpage,
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
    "recoveries": thisFileyaml["recoveries"],
    "linux": newList
  };

  deviceFile.writeAsStringSync(YAMLWriter().write(newMap));
}