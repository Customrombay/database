import 'dart:io';

import 'tools/is_supported.dart';
import 'tools/add_linux_to_support.dart';

void main() async {
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  Directory cacheDir = Directory(".cache/NixOSSync");
  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }
  cacheDir.createSync(recursive: true);
  stdout.write("Clonning https://github.com/NixOS/mobile-nixos.git...");
  Process.runSync("git", ["clone", "https://github.com/NixOS/mobile-nixos.git", cacheDir.path]);
  stdout.write("OK\n");

  for (FileSystemEntity entry in Directory("${cacheDir.path}/devices").listSync().toList()) {
    print(entry.path);
    if(entry is Directory) {
      if (!entry.path.endsWith("families")) {
        File file = File("${entry.path}/default.nix");
        String content = await file.readAsString();
        List<String> lines = content.split("\n");
        String deviceName = "";
        String deviceSupportLevel = "";
        for (String line in lines) {
          String inside = line.trim();
          if (inside.startsWith("mobile.device.name")) {
            deviceName = inside.replaceAll("mobile.device.name", "").replaceAll("=", "").replaceAll("\"", "").replaceAll(";", "").trim();
          }
          if (inside.startsWith("mobile.device.supportLevel")) {
            deviceSupportLevel = inside.replaceAll("mobile.device.supportLevel", "").replaceAll("=", "").replaceAll("\"", "").replaceAll(";", "").trim();
          }
        }
        if (deviceSupportLevel == "") {
          deviceSupportLevel = "Unsupported";
        }
        if (isSupported(extendedCodename: deviceName)) {
          numberOfCovered += 1;
          addLinuxToSupport(
            extendedCodename: deviceName,
            distributionName: "Mobile NixOS",
            distributionSupport: true,
            distributionState: deviceSupportLevel.replaceRange(0, 1, deviceSupportLevel[0].toUpperCase()),
            distributionWebpage: "https://mobile.nixos.org/index.html",
            deviceWebpage: "https://mobile.nixos.org/devices/$deviceName.html"
          );
        }
        else {
          numberOfNotCovered += 1;
          listOfNotCovered += [deviceName];
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
