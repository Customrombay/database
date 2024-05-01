import 'dart:io';
import 'tools/is_supported.dart';
import 'tools/add_to_support.dart';

void main() {
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  List<String> listOfCovered = [];
  List<Map> listOfVersions = [
    {"15" : "https://sourceforge.net/projects/xiaomi-eu-multilang-miui-roms/files/xiaomi.eu/HyperOS-STABLE-RELEASES/HyperOS1.0/"},
    {"14" : "https://sourceforge.net/projects/xiaomi-eu-multilang-miui-roms/files/xiaomi.eu/MIUI-STABLE-RELEASES/MIUIv14/"},
    {"13" : "https://sourceforge.net/projects/xiaomi-eu-multilang-miui-roms/files/xiaomi.eu/MIUI-STABLE-RELEASES/MIUIv13/"},
    {"12" : "https://sourceforge.net/projects/xiaomi-eu-multilang-miui-roms/files/xiaomi.eu/MIUI-STABLE-RELEASES/MIUIv12/"},
    {"11" : "https://sourceforge.net/projects/xiaomi-eu-multilang-miui-roms/files/xiaomi.eu/MIUI-STABLE-RELEASES/MIUIv11/"},
    {"10" : "https://xiaomi.eu/community/"}
  ];
  for (Map version in listOfVersions) {
    File resourceFile;
    if (version.keys.toList()[0] == "15") {
      resourceFile = File("filesFromXiaomiEU/xiaomi.eu.h1.txt");
    }
    else {
      resourceFile = File("filesFromXiaomiEU/xiaomi.eu${version.keys.toList()[0]}.txt");
    }
    String resourceFileContent = resourceFile.readAsStringSync();
    for (String row in resourceFileContent.split("\n")) {
      if (row != "") {
        String codename = row.split(" ")[0].replaceAll("(in)", "").split("_").first;
        print(codename);
        if (!listOfCovered.contains(codename)) {
          if (isSupported(extendedCodename: "xiaomi-$codename")) {
            numberOfCovered += 1;
            listOfCovered += [codename];
            addToSupport(
              androidVersion: "",
              extendedCodename: "xiaomi-$codename",
              romName: "xiaomi.eu",
              romState: "Official",
              romSupport: true,
              romNotes: version.keys.toList()[0] == "15" ? "HyperOS 1.0" : "MIUI ${version.keys.toList()[0]}",
              romWebpage: "https://xiaomi.eu/community/",
              deviceWebpage: version.values.toList()[0]
            );
            print("Supported");
          }
          else {
            numberOfNotCovered += 1;
            listOfNotCovered += ["xiaomi-$codename"];
            print("Not supported");
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