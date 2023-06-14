import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';

import 'tools/add_recovery_to_support.dart';
import 'tools/extended_codename_creator.dart';
import 'tools/is_supported.dart';

void main() async {
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  http.Response response = await http.get(Uri.parse("https://api.orangefox.download/v3/devices/"));
  if (response.statusCode == 200) {
    String content = response.body;
    YamlMap ydoc = loadYaml(content);
    YamlList listOfDevices = ydoc["data"];
    for (YamlMap device in listOfDevices) {
      // stdout.write(readCodename.toString() + "\n");
      String readCodename = device["codename"];
      String readVendor = device["oem_name"];
      String extendedCodename = extendedCodenameCreator(
        readCodename: (readVendor == "Asus" || readVendor == "Realme") && readCodename != "zenfone3" ? readCodename.toUpperCase() : readCodename,
        readVendor: readVendor
      );
      bool isSupportedByOrangeFox = device["supported"];
      stdout.write("$readCodename\n");
      if (isSupported(extendedCodename: extendedCodename)) {
        numberOfCovered += 1;
        addRecoveryToSupport(
          extendedCodename: extendedCodename,
          recoveryName: "OrangeFox",
          recoverySupport: true,
          recoveryState: isSupportedByOrangeFox ? "Official" : "Discontinued",
          recoveryWebpage: "https://orangefox.download/",
          deviceWebpage: "https://orangefox.download/device/$readCodename"
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
