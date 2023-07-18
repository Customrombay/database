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
  var response = await http.get(Uri.parse("https://raw.githubusercontent.com/CherishOS-Devices/OTA/tiramisu/devices.json"));
  if (response.statusCode == 200) {
    stdout.write("OK\n");
    YamlList ydoc = loadYaml(response.body);
    for (YamlMap device in ydoc) {
      String readVendor = device["brand"];
      String readCodename = device["codename"];
      String codename = readCodename;
      if (codename == "Mojito" || codename == "Sweet" || codename == "Redwood" || codename == "PHOENIX") {
        codename = codename.toLowerCase();
      }
      else if (codename == "mi8937") {
        codename = "Mi8937";
      }
      String extendedCodename = extendedCodenameCreator(readCodename: codename, readVendor: readVendor);
      stdout.write("$extendedCodename\n");
      YamlMap version = device["supported_versions"][0];
      String androidVersion = androidVersionFromCherishOSVersion(cherishOSVersion: version["version_code"].toString().toLowerCase());
      stdout.write("$androidVersion\n");

      if (isSupported(extendedCodename: extendedCodename)) {
        numberOfCovered += 1;
        addToSupport(
          androidVersion: androidVersion,
          extendedCodename: extendedCodename,
          romName: "CherishOS",
          romState: "Official",
          romSupport: true,
          romWebpage: "https://cherishos.com/",
          deviceWebpage: "https://downloads.cherishos.com/"
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

String androidVersionFromCherishOSVersion({required String cherishOSVersion}) {
  if (cherishOSVersion == "tiramisu") {
    return "13";
  }
  else if (cherishOSVersion == "twelve") {
    return "12";
  }
  else if (cherishOSVersion == "eleven") {
    return "11";
  }
  else {
    throw Exception("This CherishOS version is not supported yet");
  }
}
