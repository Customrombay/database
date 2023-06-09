import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';
import 'tools/extended_codename_creator.dart';
import 'tools/is_supported.dart';
import 'tools/add_to_support.dart';
import 'tools/android_version_from_number_name.dart';

void main() async {
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  var response = await http.get(Uri.parse("https://raw.githubusercontent.com/PixelOS-AOSP/official_devices/thirteen/API/devices.json"));
  if (response.statusCode == 200) {
    stdout.write("OK\n");
    YamlMap ydoc = loadYaml(response.body);
    YamlList listOfDevices = ydoc["devices"];
    for (YamlMap device in listOfDevices) {
      String readCodename = device["codename"];
      String readVendor = device["vendor"];
      String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: readVendor);
      String androidVersion = "";
      var deviceResponse = await http.get(Uri.parse("https://raw.githubusercontent.com/PixelOS-AOSP/official_devices/thirteen/API/devices/$readCodename.json"));
      if (deviceResponse.statusCode == 200) {
        YamlMap deviceFileContent = loadYaml(deviceResponse.body);
        androidVersion = deviceFileContent["version"];
      }
      if (isSupported(extendedCodename: extendedCodename)) {
        numberOfCovered += 1;
        addToSupport(
          androidVersion: androidVersionFromNumberName(androidVersionNumberName: androidVersion).toString(),
          extendedCodename: extendedCodename,
          romName: "PixelOS",
          romState: "Official",
          romSupport: true,
          romWebpage: "https://pixelos.net/",
          deviceWebpage: "https://pixelos.net/download/$readCodename"
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
