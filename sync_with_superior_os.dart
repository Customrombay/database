import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:http/http.dart' as http;

import 'tools/extended_codename_creator.dart';
import 'tools/is_supported.dart';
import 'tools/add_to_support.dart';
import 'tools/android_version_from_number_name.dart';

void main() async {
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfCovered = [];
  List<String> listOfNotCovered = [];
  var response1 = await http.get(Uri.parse("https://api.github.com/repos/SuperiorOS-Devices/official_devices/contents/"));
  if (response1.statusCode == 200) {
    stdout.write("OK\n");
    YamlList ydoc = loadYaml(response1.body);
    for (YamlMap file in ydoc) {
      if (file["name"].toString().endsWith(".json")) {
        stdout.write(file["name"] + "\n");
        String readCodename = file["name"].toString().replaceAll(".json", "");
        String downloadUrl = file["download_url"];
        var deviceResponse = await http.get(Uri.parse(downloadUrl));
        if (deviceResponse.statusCode == 200) {
          YamlMap deviceMap = loadYaml(deviceResponse.body);
          YamlList deviceList = deviceMap["response"];
          YamlMap deviceInfo = deviceList[0];
          String deviceName = deviceInfo["device_name"];
          String deviceBrand = deviceName.split(" ")[0];
          String superiorOSVersion = deviceInfo["version"];
          int androidVersion = androidVersionFromNumberName(androidVersionNumberName: superiorOSVersion.toLowerCase());
          String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: deviceBrand);
          if (isSupported(extendedCodename: extendedCodename)) {
            numberOfCovered += 1;
            listOfCovered += [extendedCodename];
            addToSupport(
              androidVersion: androidVersion.toString(),
              extendedCodename: extendedCodename,
              romName: "SuperiorOS",
              romState: "Official",
              romSupport: true,
              romWebpage: "https://sourceforge.net/projects/superioros/",
              deviceWebpage: "https://sourceforge.net/projects/superioros/"
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
  var response2 = await http.get(Uri.parse("https://api.github.com/repos/SuperiorOS-Devices/official_devices-gapps/contents/"));
  if (response2.statusCode == 200) {
    stdout.write("OK\n");
    YamlList ydoc = loadYaml(response2.body);
    for (YamlMap file in ydoc) {
      if (file["name"].toString().endsWith(".json")) {
        stdout.write(file["name"] + "\n");
        String readCodename = file["name"].toString().replaceAll(".json", "");
        String downloadUrl = file["download_url"];
        var deviceResponse = await http.get(Uri.parse(downloadUrl));
        if (deviceResponse.statusCode == 200) {
          YamlMap deviceMap = loadYaml(deviceResponse.body);
          YamlList deviceList = deviceMap["response"];
          YamlMap deviceInfo = deviceList[0];
          String deviceName = deviceInfo["device_name"];
          String deviceBrand = deviceName.split(" ")[0];
          String superiorOSVersion = deviceInfo["version"];
          int androidVersion = androidVersionFromNumberName(androidVersionNumberName: superiorOSVersion.toLowerCase());
          String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: deviceBrand);
          if (!(listOfCovered.contains(extendedCodename))) {
            if (isSupported(extendedCodename: extendedCodename)) {
              numberOfCovered += 1;
              listOfCovered += [extendedCodename];
              addToSupport(
                androidVersion: androidVersion.toString(),
                extendedCodename: extendedCodename,
                romName: "SuperiorOS",
                romState: "Official",
                romSupport: true,
                romWebpage: "https://sourceforge.net/projects/superioros/",
                deviceWebpage: "https://sourceforge.net/projects/superioros/"
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
  }
  stdout.write("Covered: $numberOfCovered\n");
  stdout.write("Not covered: $numberOfNotCovered\n");
  for (var deviceNotCovered in listOfNotCovered) {
    stdout.write("$deviceNotCovered\n");
  }
}