import 'dart:io';

import 'package:yaml/yaml.dart';

import 'tools/add_to_support.dart';
import 'tools/extended_codename_creator.dart';
import 'tools/is_supported.dart';

void main() async {
  stdout.write("Cloning https://gitlab.e.foundation/e/documentation/user.git...\n");
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  // List<String> listOfCovered = [];
  Directory cacheDir = Directory(".cache/eOSSync");
  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }
  cacheDir.createSync(recursive: true);
  var process = await Process.start("git", ["clone", "https://gitlab.e.foundation/e/documentation/user.git", cacheDir.path], mode: ProcessStartMode.inheritStdio);
  int exitCode = await process.exitCode;
  if (exitCode == 0) {
    stdout.write("OK\n");
    for (FileSystemEntity entry in Directory("${cacheDir.path}/htdocs/_data/devices").listSync().toList()) {
      stdout.write("${entry.path}\n");
      if (entry is File) {
        String content = await entry.readAsString();
        List<String> listOfLines = content.split("\n");
        List<String> listOfParsedLines = [];
        for (String line in listOfLines) {
          String firstPart = line.split(":").first;
          bool repeats = false;
          for (String parsedLine in listOfParsedLines) {
            String parsedFirstPart = parsedLine.split(":").first;
            if (firstPart == parsedFirstPart) {
              repeats = true;
            }
          }
          if (!repeats) {
            listOfParsedLines += [line];
          }
        }
        content = listOfParsedLines.join("\n");
        YamlMap yamlMap = loadYaml(content);
        String devVersion = yamlMap["build_version_dev"] ?? "";
        String? stableVersion = yamlMap["build_version_stable"];
        String? isLegacy = yamlMap["legacy"];
        String androidVersion;
        String romStatus;
        if (stableVersion != null) {
          androidVersion = androidVersionFromeOSVersion(stableVersion);
          romStatus = "Official";
        }
        else {
          androidVersion = androidVersionFromeOSVersion(devVersion);
          romStatus = "Community";
        }
        if (isLegacy != null) {
          if (isLegacy == "yes") {
            romStatus = "Discontinued";
          }
          else {
            throw Exception();
          }
        }
        print(androidVersion);
        String codename = yamlMap["codename"];
        String manufacturer = yamlMap["vendor_short"] ?? (yamlMap["vendor"] as String).toLowerCase();
        String extendedCodename = extendedCodenameCreator(readCodename: codename, readVendor: manufacturer);
        if (isSupported(extendedCodename: extendedCodename)) {
          // listOfCovered += [extendedCodename];
          numberOfCovered += 1;
          addToSupport(
            androidVersion: androidVersion,
            extendedCodename: extendedCodename,
            romName: "/e/OS",
            romState: romStatus,
            romSupport: true,
            romWebpage: "https://e.foundation/e-os/",
            deviceWebpage: "https://doc.e.foundation/devices/$codename",
          );
        }
        else {
          listOfNotCovered += [extendedCodename];
          numberOfNotCovered += 1;
        }
      }
    }

    stdout.write("Covered: $numberOfCovered\n");
    stdout.write("Not covered: $numberOfNotCovered\n");
    for (String device in listOfNotCovered) {
      stdout.write("$device\n");
    }
  }
}

String androidVersionFromeOSVersion(String eOSVersion) {
  if (eOSVersion == "Q") {
    return "10";
  }
  else if (eOSVersion == "R") {
    return "11";
  }
  else if (eOSVersion == "S") {
    return "12";
  }
  else if (eOSVersion == "T") {
    return "13";
  }
  else if (eOSVersion == "U") {
    return "14";
  }
  else if (eOSVersion == "Oreo") {
    return "8";
  }
  else if (eOSVersion == "Pie") {
    return "9";
  }
  else if (eOSVersion == "Nougat") {
    return "7";
  }
  else {
    throw Exception("This version of eOS ($eOSVersion) is not supported yet!");
  }
}