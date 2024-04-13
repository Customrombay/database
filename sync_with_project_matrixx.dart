import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';
import 'tools/extended_codename_creator.dart';
import 'tools/is_supported.dart';
import 'tools/add_to_support.dart';

void main() async {
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  var response = await http.get(Uri.parse("https://github.com/Matrixx-Devices/official_devices/raw/14.0/devices.json"));
  if (response.statusCode == 200) {
    stdout.write("OK\n");
    YamlMap ydoc = loadYaml(response.body);
    for (YamlMap device in ydoc["devices"]) {
      String readVendor = device["vendor"];
      String readCodename = device["codename"];
      String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: readVendor);
      stdout.write("$extendedCodename\n");
      bool isActive = device["active"];

      if (isSupported(extendedCodename: extendedCodename)) {
        numberOfCovered += 1;
        addToSupport(
          androidVersion: "14",
          extendedCodename: extendedCodename,
          romName: "Project Matrixx",
          romState: isActive ? "Official" : "Unofficial",
          romSupport: true,
          romWebpage: "https://www.projectmatrixx.org/",
          deviceWebpage: "https://www.projectmatrixx.org/downloads/$readCodename"
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
