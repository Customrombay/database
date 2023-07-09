import 'dart:io';
import 'package:yaml/yaml.dart';
import 'tools/add_to_support.dart';
import 'tools/extended_codename_creator.dart';
import 'tools/is_supported.dart';

void main() async {
  stdout.write("Cloning https://github.com/AOSPA/ota.git...");
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  List<String> listOfCovered = [];
  Directory cacheDir = Directory(".cache/ParanoidAndroidSync");
  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }
  cacheDir.createSync(recursive: true);
  Process.runSync("git", ["clone", "https://github.com/AOSPA/ota.git", cacheDir.path]);
  stdout.write("OK\n");

  File devicesFile = File("${cacheDir.path}/devices");
  YamlMap ydoc = loadYaml(devicesFile.readAsStringSync());
  YamlList ylist = ydoc["devices"];


  for (YamlMap device in ylist) {
    String readName = device["name"];
    String readCodename = device["codename"];
    String readVendor = device["manufacturer"];
    bool isActive = device["active"] ?? false;

    String vendor = readVendor == "Redmi" || readVendor == "POCO" ? "xiaomi" : readVendor;

    print(readName);
    String extendedCodename = extendedCodenameCreator(
      readCodename: readCodename,
      readVendor: vendor
    );

    File updateFile = File("${cacheDir.path}/updates/$readCodename");

    int maxAndroidVersion = 0;

    if (updateFile.existsSync()) {
      YamlMap uydoc = loadYaml(updateFile.readAsStringSync());
      YamlList listOfUpdates = uydoc["updates"];

      for (YamlMap update in listOfUpdates) {
        int androidVersion = int.parse(update["android_version"]);
        if (androidVersion > maxAndroidVersion) {
          maxAndroidVersion = androidVersion;
        }
      }
    }
    else {
      throw Exception();
    }

    if (isSupported(extendedCodename: extendedCodename) && !listOfCovered.contains(extendedCodename)) {
      numberOfCovered += 1;
      listOfCovered += [extendedCodename];
      addToSupport(
        extendedCodename: extendedCodename,
        romName: "Paranoid Android",
        romState: isActive ? "Official" : "Discontinued",
        romSupport: true,
        androidVersion: maxAndroidVersion.toString(),
        romWebpage: "https://paranoidandroid.co/",
        deviceWebpage: "https://paranoidandroid.co/$readCodename"
      );
    }
    else if (!listOfNotCovered.contains(extendedCodename) && !listOfCovered.contains(extendedCodename)) {
      numberOfNotCovered += 1;
      listOfNotCovered += [extendedCodename];
    }
  }
  stdout.write("Covered: $numberOfCovered\n");
  stdout.write("Not covered: $numberOfNotCovered\n");
  for (var device in listOfNotCovered) {
    stdout.write("$device\n");
  }
}
