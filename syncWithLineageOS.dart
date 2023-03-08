import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:http/http.dart' as http;
import 'package:yaml_writer/yaml_writer.dart';
// import 'tools/codename_correction.dart'
import 'tools/extended_codename_creator.dart';
import 'tools/android_version_from_lineageos_version.dart';

void main() async {
  var response = await http.get(Uri.parse("https://api.github.com/repos/LineageOS/lineage_wiki/contents/_data/devices/"));
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  if (response.statusCode == 200) {
    stdout.write("OK\n");
    YamlList ydoc = loadYaml(response.body);
    for (var deviceFile in ydoc) {
      String downloadUrl = deviceFile["download_url"];
      var thisresponse = await http.get(Uri.parse(downloadUrl));
      if (thisresponse.statusCode == 200) {
        stdout.write("""${deviceFile["name"]}... OK\n""");
        YamlMap thisydoc = loadYaml(thisresponse.body);
        stdout.write(thisydoc["name"] + "\n");
        List thisList = await updateDeviceFiles(thisresponse.body);
        if (thisList[0]) {
          numberOfCovered += 1;
        }
        else {
          numberOfNotCovered += 1;
          listOfNotCovered += [thisList[1]];
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

Future<List> updateDeviceFiles(String content) async {
  var ydoc = loadYaml(content);
  var vendor = ydoc["vendor"];
  var name = ydoc["name"];
  var readCodename = ydoc["codename"];

  // String codename = codenameCorrection(readCodename, vendor);
  String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: vendor);

  var androidVersion = "";
  var lineageOSversion = ydoc["current_branch"];
  var image = ydoc["image"];
  var maintainers = ydoc["maintainers"];
  var state = "";
  var phoneWebpage = "https://wiki.lineageos.org/devices/$readCodename/";

  androidVersion = androidVersionFromLineageOSVersion(lineageOSversion.toString());
  if (maintainers.length > 0) {
    state = "Official";
  }
  else {
    state = "Discontinued";
  }

  //stdout.write(vendor + "\n");

  bool thisCovered = false;

  if (await File("database/phone_data/$extendedCodename.yaml").exists()) {
    stdout.write("$extendedCodename \n");
    thisCovered = true;
    //stdout.write(numberOfCovered.toString() + "\n");
  }

  if (thisCovered) {
    File thisFile = File("database/phone_data/$extendedCodename.yaml");
    String thisFileContent = await thisFile.readAsString();
    var thisFileyaml = loadYaml(thisFileContent);

    List newList = [];
    bool alreadySupported = false;
    for (var thisRom in thisFileyaml["roms"]) {
      String thisRomName = thisRom["rom-name"];
      if (thisRomName == "LineageOS") {
        alreadySupported = true;
        newList += [
          {
            "rom-name": "LineageOS",
            "rom-support": true,
            "rom-state": state,
            "android-version": androidVersion,
            "rom-webpage": "https://lineageos.org/",
            "phone-webpage": phoneWebpage
          }
        ];
      }
      else {
        newList += [thisRom];
      }
    }

    if (!alreadySupported) {
      newList = <dynamic>[
        {
          "rom-name": "LineageOS",
          "rom-support": true,
          "rom-state": state,
          "android-version": androidVersion,
          "rom-webpage": "https://lineageos.org/",
          "phone-webpage": phoneWebpage
        }
      ] + newList;
    }

    Map newMap = {
      "device-name" : thisFileyaml["device-name"],
      "device-vendor": thisFileyaml["device-vendor"],
      "device-model-name": thisFileyaml["device-model-name"],
      "device-description": thisFileyaml["device-description"],
      "roms": newList,
      "recoveries": thisFileyaml["recoveries"]
    };

    // File newFile = File("newfiles/${vendor.toString().toLowerCase()}-$codename.yaml");
    await thisFile.writeAsString(YAMLWriter().write(newMap));
  }
  return [thisCovered, extendedCodename];
}