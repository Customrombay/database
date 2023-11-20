import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:http/http.dart' as http;

import 'tools/add_to_support.dart';
import 'tools/extended_codename_creator.dart';
import 'tools/is_supported.dart';

void main() async {
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  var response = await http.get(Uri.parse("https://raw.githubusercontent.com/DroidX-UI-Devices/Official_Devices/13/website.json"));
  if (response.statusCode == 200) {
    stdout.write("OK\n");
    YamlMap devices = loadYaml(response.body);
    YamlList listOfDevices = devices["devices"];
    for (YamlMap device in listOfDevices) {
      var readCodename = device["codename"];
      var readVendor = device["vendor"];
      bool isActive = device["active"];
      // var status = device["status"];
      var codename = readCodename;
      if (readVendor.toString().toLowerCase() == "xiaomi") {
        codename = codename.toString().toLowerCase();
      }

      String extendedCodename = extendedCodenameCreator(readCodename: codename, readVendor: readVendor);

      if (isSupported(extendedCodename: extendedCodename)) {
        numberOfCovered += 1;
        addToSupport(
          androidVersion: "13",
          extendedCodename: extendedCodename,
          romName: "DroidX-UI",
          romState: isActive ? "Official" : "Discontinued",
          romSupport: true,
          romWebpage: "https://github.com/DroidX-UI",
          deviceWebpage: "https://sourceforge.net/projects/droidxui-releases/files/$codename/",
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