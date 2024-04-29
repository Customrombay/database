import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';
import 'tools/add_to_support.dart';
import 'tools/android_version_from_crdroid_version.dart';
import 'tools/extended_codename_creator.dart';
import 'tools/is_supported.dart';

void main() async {
  var response = await http.get(Uri.parse("https://crdroid.net/devices_handler/compiled.json"));
  if (response.statusCode == 200) {
    print("OK");
    int numberOfCovered = 0;
    int numberOfNotCovered = 0;
    List<String> listOfNotCovered = [];
    List<String> listOfCovered = [];
    String cleanBody = response.body.replaceAll("\\ud835\\udd71\\ud835\\udd97\\ud835\\udd94\\ud835\\udd98\\ud835\\udd99", "ok");
    YamlMap ydoc = loadYaml(cleanBody);
    print(ydoc.runtimeType);
    for (var entry in ydoc.entries) {
      print(entry.key);
      String readVendor = entry.key;

      YamlMap devices = entry.value;

      for (var readCodename in devices.keys) {
        if (readCodename == "tulip") {
          continue;
        }
        else if (readCodename == "olives") {
          continue;
        }
        else if (readCodename == "olive") {
          continue;
        }
        else if (readCodename == "rova") {
          continue;
        }
        else if (readCodename == "Mi439" && readVendor.toLowerCase() == "redmi") {
          continue;
        }
        else if (readCodename == "RMX2001") {
          continue;
        }
        else if (readCodename == "RMX2151") {
          continue;
        }
        String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: readVendor);
        print(extendedCodename);
        int newestVersion = 0;
        YamlMap versions = devices[readCodename];
        bool isMaintained = false;
        for (var version in versions.keys) {
          print(version);
          int thisVersion = int.parse(version.toString());
          if (thisVersion > newestVersion) {
            newestVersion = thisVersion;
          }
          YamlMap finals = versions[version];
          // String deviceName = finals["device"];
          String maintainers = finals["maintainer"];
          if (maintainers != "") {
            isMaintained = true;
          }
        }
        String state = isMaintained ? "Official" : "Discontinued";
        String phoneWebpage = "https://crdroid.net/downloads#$readCodename";
        print(newestVersion);
        String androidVersion = androidVersionFromCrDroidVersion(newestVersion.toString());
        if (isSupported(extendedCodename: extendedCodename)) {
          if (listOfCovered.contains(extendedCodename)) {
            throw Exception();
          }
          addToSupport(
            androidVersion: androidVersion,
            extendedCodename: extendedCodename,
            romName: "crDroid",
            romState: state,
            romSupport: true,
            romWebpage: "https://crdroid.net/",
            deviceWebpage: phoneWebpage,
          );
          numberOfCovered += 1;
          listOfCovered += [extendedCodename];
        }
        else {
          numberOfNotCovered += 1;
          listOfNotCovered += [extendedCodename];
        }
      }
    }
    stdout.write("Covered: $numberOfCovered\n");
    stdout.write("Not covered: $numberOfNotCovered\n");
    for (var deviceNotCovered in listOfNotCovered) {
      stdout.write("$deviceNotCovered\n");
    }
  }
  else {
    throw Exception();
  }
}