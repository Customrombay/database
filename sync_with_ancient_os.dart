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
  var response = await http.get(Uri.parse("https://raw.githubusercontent.com/ancient-devices/official/13T/ancient.devices"));
  String codenameFileContent = File("assets/vendor_by_codename.yaml").readAsStringSync();
  YamlList listOfCodenames = loadYaml(codenameFileContent);
  if (response.statusCode == 200) {
    stdout.write("OK\n");
    List<String> listOfReadCodenames = response.body.split("\n");
    for (String readCodename in listOfReadCodenames) {
      if (readCodename.trim() != "") {
        String readVendor = "";
        for (YamlMap codename in listOfCodenames) {
          if (codename["codename"] == readCodename) {
            readVendor = codename["vendors"][0];
          }
        }
        if (readVendor == "") {
          stdout.write("\x1B[33mNo vendor found for $readCodename!\x1B[0m\n");
        }
        else {
          String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: readVendor);
          stdout.write("$extendedCodename\n");

          if (isSupported(extendedCodename: extendedCodename)) {
            numberOfCovered += 1;
            addToSupport(
              androidVersion: "13",
              extendedCodename: extendedCodename,
              romName: "AncientOS",
              romState: "Official",
              romSupport: true,
              romWebpage: "https://sourceforge.net/projects/ancientrom/",
              romNotes: ""
            );
          }
          else {
            numberOfNotCovered += 1;
            listOfNotCovered += [extendedCodename];
          }
        }
      }
    }
    
    stdout.write("Covered: $numberOfCovered\n");
    stdout.write("Not covered: $numberOfNotCovered\n");
    for (var deviceNotCovered in listOfNotCovered) {
      stdout.write("$deviceNotCovered\n");
    }
  }
}