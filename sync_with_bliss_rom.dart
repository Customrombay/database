import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:http/http.dart' as http;

import 'tools/extended_codename_creator.dart';
import 'tools/is_supported.dart';
import 'tools/add_to_support.dart';

void main() async {
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  var response = await http.get(Uri.parse("https://raw.githubusercontent.com/BlissRoms-Devices/official-devices/main/devices.json"));
  if (response.statusCode == 200) {
    stdout.write("OK\n");
    YamlList ydoc = loadYaml(response.body);
    for (YamlMap device in ydoc) {
      String readVendor = device["brand"];
      String readCodename = device["codename"];
      String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: readVendor);
      if (isSupported(extendedCodename: extendedCodename)) {
        numberOfCovered += 1;
        addToSupport(
          extendedCodename: extendedCodename,
          romName: "BlissROM",
          romState: "Official",
          romSupport: true,
          romWebpage: "https://blissroms.org/",
          deviceWebpage: "https://downloads.blissroms.org/download/$readCodename/"
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