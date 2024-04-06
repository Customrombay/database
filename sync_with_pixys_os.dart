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
