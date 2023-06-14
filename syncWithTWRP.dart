import 'dart:io';
import 'package:yaml/yaml.dart';

import 'tools/extended_codename_creator.dart';
import 'tools/is_supported.dart';
import 'tools/add_recovery_to_support.dart';

void main() async {
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfCovered = [];
  List<String> listOfNotCovered = [];
  List<String> listOfProblematic = [];
  Directory cacheDir = Directory(".cache/TWRPSync");
  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }
  cacheDir.createSync(recursive: true);
  Process.runSync("git", ["clone", "https://github.com/TeamWin/twrpme.git", cacheDir.path]);
  stdout.write("OK\n");
  for (FileSystemEntity entry in cacheDir.listSync().toList()) {
    if (entry is Directory && entry.path.split("/").last.startsWith("_") && !(["_oem", "_app", "_drafts", "_faq", "_terms", "_posts"].contains(entry.path.split("/").last))) {
      for (FileSystemEntity deviceFile in entry.listSync().toList()) {
        if (deviceFile is File && deviceFile.path.endsWith(".markdown")) {
          String content = deviceFile.readAsStringSync();
          String deviceFileName = deviceFile.path.split("/").last;
          String deviceVendorName = deviceFile.path.split("/")[deviceFile.path.split("/").length - 2].replaceFirst("_", "");
          try {
            YamlMap ydoc = loadYaml(content.split("---")[1]);
            String readCodename = ydoc["codename"];
            if (readCodename.contains("/")) {
              List<String> codenameList = readCodename.split("/");
              readCodename = codenameList[0].trim();
            }
            else if (readCodename.contains(",")) {
              List<String> codenameList = readCodename.split(",");
              readCodename = codenameList[0].trim();
            }
            String readVendor = ydoc["oem"];
            String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: readVendor);
            String supportStatus = ydoc["supportstatus"] ?? "Unspecified";
            String deviceWebpage = "https://twrp.me/$deviceVendorName/${deviceFileName.replaceAll(".markdown", ".html")}";
            if (isSupported(extendedCodename: extendedCodename)) {
              if (listOfCovered.contains(extendedCodename)) {
                continue;
              }
              numberOfCovered += 1;
              listOfCovered += [extendedCodename];
              addRecoveryToSupport(
                extendedCodename: extendedCodename,
                recoveryName: "TWRP",
                recoverySupport: true,
                recoveryState: supportStatus,
                recoveryWebpage: "https://twrp.me/",
                deviceWebpage: deviceWebpage
              );
            }
            else {
              numberOfNotCovered += 1;
              listOfNotCovered += [extendedCodename];
            }
            
          } catch (e) {
            listOfProblematic += [deviceFile.path];
          }
        }
      }
    }
  }
  stdout.write("END\n");
  for (String problematicFile in listOfProblematic) {
    stdout.write(problematicFile + "\n");
  }
  stdout.write("Covered: $numberOfCovered\n");
  stdout.write("Not covered: $numberOfNotCovered\n");
  for (var deviceNotCovered in listOfNotCovered) {
    stdout.write("$deviceNotCovered\n");
  }
}
