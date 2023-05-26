import 'dart:io';
import 'tools/is_supported.dart';
import 'tools/add_to_support.dart';

void main() {
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  File resourceFile = File("filesFromXiaomiEU/xiaomi.eu.txt");
  String resourceFileContent = resourceFile.readAsStringSync();
  for (String row in resourceFileContent.split("\n")) {
    if (row != "") {
      String codename = row.split(" ")[0].replaceAll("(in)", "");
      print(codename);
      if (isSupported(extendedCodename: "xiaomi-$codename")) {
        numberOfCovered += 1;
        addToSupport(
          androidVersion: "13",
          extendedCodename: "xiaomi-$codename",
          romName: "xiaomi.eu",
          romState: "Official",
          romSupport: true,
          romWebpage: "https://xiaomi.eu/community/",
          deviceWebpage: "https://sourceforge.net/projects/xiaomi-eu-multilang-miui-roms/files/xiaomi.eu/MIUI-STABLE-RELEASES/MIUIv14/"
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
  stdout.write("Covered: $numberOfCovered\n");
  stdout.write("Not covered: $numberOfNotCovered\n");
  for (var deviceNotCovered in listOfNotCovered) {
    stdout.write("$deviceNotCovered\n");
  }
}