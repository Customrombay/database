import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';
import 'tools/extended_codename_creator.dart';
import 'tools/android_version_from_number_name.dart';
import 'tools/is_supported.dart';
import 'tools/add_to_support.dart';

void main() async {
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  var response = await http.get(Uri.parse("https://raw.githubusercontent.com/Evolution-X-Devices/official_devices/master/devices.json"));
  if (response.statusCode == 200) {
    stdout.write("OK\n");
    YamlList deviceList = loadYaml(response.body);
    for (YamlMap device in deviceList) {
      String codename = device["codename"];
      String vendor = device["brand"];
      String extendedCodename = extendedCodenameCreator(readCodename: codename, readVendor: vendor);
      YamlList supportedVersions = device["supported_versions"];
      YamlMap thisversion = supportedVersions[0];
      String evolutionXVersion = thisversion["version_code"];
      String androidVersion = androidVersionFromNumberName(androidVersionNumberName: evolutionXVersion.toLowerCase()).toString();
      stdout.write("$extendedCodename\n");
      if (isSupported(extendedCodename: extendedCodename)) {
        numberOfCovered += 1;
        addToSupport(
          androidVersion: androidVersion,
          extendedCodename: extendedCodename,
          romName: "EvolutionX",
          romState: "Official",
          romSupport: true,
          romWebpage: "https://evolution-x.org/",
          deviceWebpage: "https://evolution-x.org/device/$codename"
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
