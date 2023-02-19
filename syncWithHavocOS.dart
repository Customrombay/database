import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';
import 'tools/codename_correction.dart';
import 'tools/extended_codename_creator.dart';
import 'tools/add_to_support.dart';

void main() async {
  var yamlWriter = YAMLWriter();
  int numberOfCovered = 0;
  int numberOfNotCovered = 0;
  List<String> listOfNotCovered = [];
  List<String> listOfCovered = [];
  for (var file in await Directory("filesFromHavocOS/twelve/gapps/").list().toList()) {
    String content = await File(file.path).readAsString();
    stdout.write(file.path + "\n");
    var ydoc = loadYaml(content);
    String readVendor = ydoc["oem"];
    String vendor = readVendor;
    if (readVendor.toLowerCase() == "poco") {
      vendor = "Xiaomi";
    }
    String readCodename = ydoc["codename"];
    String codename = codenameCorrection(readCodename, vendor);
    String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: readVendor);

    if (File("database/phone_data/$extendedCodename.yaml").existsSync()) {
      numberOfCovered += 1;
      listOfCovered += [extendedCodename];
      addToSupport(androidVersion: "12", extendedCodename: extendedCodename, romName: "HavocOS", romState: "Official", romSupport: true, romWebpage: "https://havoc-os.com/", deviceWebpage: "https://havoc-os.com/device#$readCodename");
    }
    else {
      numberOfNotCovered += 1;
      listOfNotCovered += [extendedCodename];
    }
  }

  for (var file in await Directory("filesFromHavocOS/eleven/gapps/").list().toList()) {
    String content = await File(file.path).readAsString();
    stdout.write(file.path + "\n");
    var ydoc = loadYaml(content);
    String readVendor = ydoc["oem"];
    String vendor = readVendor;
    if (readVendor.toLowerCase() == "poco") {
      vendor = "Xiaomi";
    }
    String readCodename = ydoc["codename"];
    String codename = codenameCorrection(readCodename, vendor);
    String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: readVendor);

    if (!(listOfCovered.contains(extendedCodename)) && !(listOfNotCovered.contains(extendedCodename))) {
      if (File("database/phone_data/$extendedCodename.yaml").existsSync()) {
        numberOfCovered += 1;
        listOfCovered += [extendedCodename];
        addToSupport(androidVersion: "11", extendedCodename: extendedCodename, romName: "HavocOS", romState: "Official", romSupport: true, romWebpage: "https://havoc-os.com/", deviceWebpage: "https://havoc-os.com/device#$readCodename");
      }
      else {
        numberOfNotCovered += 1;
        listOfNotCovered += [extendedCodename];
      }
    }
  }

  for (var file in await Directory("filesFromHavocOS/eleven/vanilla/").list().toList()) {
    String content = await File(file.path).readAsString();
    stdout.write(file.path + "\n");
    var ydoc = loadYaml(content);
    String readVendor = ydoc["oem"];
    String vendor = readVendor;
    if (readVendor.toLowerCase() == "poco") {
      vendor = "Xiaomi";
    }
    String readCodename = ydoc["codename"];
    String codename = codenameCorrection(readCodename, vendor);
    String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: readVendor);

    if (!(listOfCovered.contains(extendedCodename)) && !(listOfNotCovered.contains(extendedCodename))) {
      if (File("database/phone_data/$extendedCodename.yaml").existsSync()) {
        numberOfCovered += 1;
        listOfCovered += [extendedCodename];
        addToSupport(androidVersion: "11", extendedCodename: extendedCodename, romName: "HavocOS", romState: "Official", romSupport: true, romWebpage: "https://havoc-os.com/", deviceWebpage: "https://havoc-os.com/device#$readCodename");
      }
      else {
        numberOfNotCovered += 1;
        listOfNotCovered += [extendedCodename];
      }
    }
  }

  for (var file in await Directory("filesFromHavocOS/ten/gapps/").list().toList()) {
    String content = await File(file.path).readAsString();
    stdout.write(file.path + "\n");
    var ydoc = loadYaml(content);
    List response = ydoc["response"];
    Map toParse = response[0];
    String readVendor = toParse["oem"];
    String vendor = readVendor;
    if (readVendor.toLowerCase() == "poco") {
      vendor = "Xiaomi";
    }
    String readCodename = toParse["codename"];
    String codename = codenameCorrection(readCodename, vendor);
    String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: readVendor);

    if (!(listOfCovered.contains(extendedCodename)) && !(listOfNotCovered.contains(extendedCodename))) {
      if (File("database/phone_data/$extendedCodename.yaml").existsSync()) {
        numberOfCovered += 1;
        listOfCovered += [extendedCodename];
        addToSupport(androidVersion: "10", extendedCodename: extendedCodename, romName: "HavocOS", romState: "Official", romSupport: true, romWebpage: "https://havoc-os.com/", deviceWebpage: "https://havoc-os.com/device#$readCodename");
      }
      else {
        numberOfNotCovered += 1;
        listOfNotCovered += [extendedCodename];
      }
    }
  }

  for (var file in await Directory("filesFromHavocOS/ten/vanilla/").list().toList()) {
    String content = await File(file.path).readAsString();
    stdout.write(file.path + "\n");
    var ydoc = loadYaml(content);
    List response = ydoc["response"];
    Map toParse = response[0];
    String readVendor = toParse["oem"];
    String vendor = readVendor;
    if (readVendor.toLowerCase() == "poco") {
      vendor = "Xiaomi";
    }
    String readCodename = toParse["codename"];
    String codename = codenameCorrection(readCodename, vendor);
    String extendedCodename = extendedCodenameCreator(readCodename: readCodename, readVendor: readVendor);

    if (!(listOfCovered.contains(extendedCodename)) && !(listOfNotCovered.contains(extendedCodename))) {
      if (File("database/phone_data/$extendedCodename.yaml").existsSync()) {
        numberOfCovered += 1;
        listOfCovered += [extendedCodename];
        addToSupport(androidVersion: "10", extendedCodename: extendedCodename, romName: "HavocOS", romState: "Official", romSupport: true, romWebpage: "https://havoc-os.com/", deviceWebpage: "https://havoc-os.com/device#$readCodename");
      }
      else {
        numberOfNotCovered += 1;
        listOfNotCovered += [extendedCodename];
      }
    }
  }

  stdout.write("Covered: $numberOfCovered\n");
  stdout.write("Not covered: $numberOfNotCovered\n");
  for (var device in listOfNotCovered) {
    stdout.write("$device\n");
  }

}
