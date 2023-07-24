import 'dart:io';
import 'package:http/http.dart' as http;
import 'tools/extended_codename_creator.dart';
import 'tools/is_supported.dart';
import 'tools/add_linux_to_support.dart';

void main() async {
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  RegExp exp = RegExp(r'<a href=".+" title=".+">.+<\/a> \(<span class="cargoFieldName">Codename:<\/span> .+\)<\/li>');
  String status = "Testing";
  var response = await http.get(Uri.parse("https://wiki.postmarketos.org/wiki/Devices"));
  if (response.statusCode == 200) {
    stdout.write("OK\n");
    // print(response.body);
    List<String> list1 = response.body.split("<li>");
    for (String item in list1) {
      if (exp.hasMatch(item) && item.trim().endsWith(")</li>")) {
        String deviceCodename = item.replaceFirst(RegExp(r'<a href=".+" title=".+">.+<\/a> \(<span class="cargoFieldName">Codename:<\/span> '), "").replaceFirst(")</li>", "").trim();
        String deviceWebpage = "https://wiki.postmarketos.org${item.replaceFirst(RegExp(r'<a href="'), "").replaceFirst(RegExp(r'" title=".+">.+<\/a> \(<span class="cargoFieldName">Codename:<\/span> .+\)<\/li>'), "").trim()}";
        if (RegExp(r".+-.+").hasMatch(deviceCodename)) {
          List<String> deviceCodenameList = deviceCodename.split("-");
          String readVendor = deviceCodenameList[0];
          String readCodename = deviceCodenameList[1];
          String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: readVendor);
          print(deviceCodename);
          if (isSupported(extendedCodename: extendedCodename)) {
            numberOfCovered += 1;
            addLinuxToSupport(
              extendedCodename: extendedCodename,
              distributionName: "PostmarketOS",
              distributionSupport: true,
              distributionState: status,
              distributionWebpage: "https://postmarketos.org/",
              deviceWebpage: deviceWebpage
            );
          }
          else {
            numberOfNotCovered += 1;
          }
        }
      }
      else {
        if (item.contains("Non-booting devices")) {
          status = "Non-booting";
        }
      }
    }
  }

  stdout.write("Covered: $numberOfCovered\n");
  stdout.write("Not covered: $numberOfNotCovered\n");
  for (var device in listOfNotCovered) {
    stdout.write("$device\n");
  }
}
