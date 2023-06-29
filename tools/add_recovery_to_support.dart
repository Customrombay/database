import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

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
    "recoveries": newList,
    "linux": thisFileyaml["linux"],
  };

  deviceFile.writeAsStringSync(YAMLWriter().write(newMap));
}