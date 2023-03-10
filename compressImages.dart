import 'dart:io';

void main() async {
  for (var file in await Directory("database/device_images/big/").list().toList()) {
    var newpath = file.path.replaceAll("big", "small").replaceAll(".png", ".webp");
    stdout.write("Compressing ${file.path}...\n");
    //await Process.run("convert", [file.path, "-resize", "300", "-quality", "80", newpath]);
    await Process.run("convert", [file.path, "-quality", "80", newpath]);
    newpath = file.path.replaceAll("big", "medium").replaceAll(".png", ".webp");
    await Process.run("convert", [file.path, "-quality", "95", newpath]);
  }
}