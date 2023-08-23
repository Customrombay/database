import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';
import 'tools/android_version_from_number_name.dart';
import 'tools/extended_codename_creator.dart';
import 'tools/is_supported.dart';
import 'tools/add_to_support.dart';

void main() async {
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  var baseFileResponse = await http.get(Uri.parse("https://git.libremobileos.com/infrastructure/builder/-/raw/main/lmodroid-build-targets"));
  var devicesFileResponse = await http.get(Uri.parse("https://git.libremobileos.com/infrastructure/builder/-/raw/main/devices.json"));
  if (baseFileResponse.statusCode == 200 && devicesFileResponse.statusCode == 200) {
    stdout.write("OK\n");
    String baseFileContent = baseFileResponse.body;
    YamlList ydoc = loadYaml(devicesFileResponse.body);
    for (String line in baseFileContent.split("\n")) {
      if (line.trim() != "" && !line.trim().startsWith("#")) {
        List<String> props = line.trim().split(" ");
        String readCodename = props[0];
        String androidVersion = androidVersionFromNumberName(androidVersionNumberName: props[2]).toString();
        for (YamlMap device in ydoc) {
          if (device["model"] == readCodename) {
            String readVendor = device["oem"];
            String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: readVendor);
            if (isSupported(extendedCodename: extendedCodename)) {
              numberOfCovered += 1;
              addToSupport(
                androidVersion: androidVersion,
                extendedCodename: extendedCodename,
                romName: "LibreMobileOS",
                romState: "Official",
                romSupport: true,
                romWebpage: "https://libremobileos.com/",
                deviceWebpage: "https://get.libremobileos.com/devices/$readCodename/",
              );
            }
            else {
              numberOfNotCovered += 1;
              listOfNotCovered += [extendedCodename];
            }
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
