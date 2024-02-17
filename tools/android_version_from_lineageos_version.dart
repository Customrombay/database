String androidVersionFromLineageOSVersion(String lineageOSVersion) {
  if (lineageOSVersion == "21" || lineageOSVersion == "21.0") {
    return "14";
  }
  else if (lineageOSVersion == "20" || lineageOSVersion == "20.0") {
    return "13";
  }
  else if (lineageOSVersion == "19.1") {
    return "12L";
  }
  else if (lineageOSVersion == "18.1") {
    return "11";
  }
  else if (lineageOSVersion == "17.1") {
    return "10";
  }
  else if (lineageOSVersion == "16.0") {
    return "9";
  }
  else if (lineageOSVersion == "15.1") {
    return "8.1";
  }
  else if (lineageOSVersion == "14.1") {
    return "7.1";
  }
  else if (lineageOSVersion == "13.0") {
    return "6";
  }
  else if (lineageOSVersion == "12.1") {
    return "5.1";
  }
  else if (lineageOSVersion == "12.0") {
    return "5.0";
  }
  else if (lineageOSVersion == "11.0") {
    return "4.4.4";
  }
  else if (lineageOSVersion == "10.0") {
    return "4.1.2";
  }
  else if (lineageOSVersion == "9.0") {
    return "4.0.4";
  }
  else {
    throw Exception("This version of LineageOS ($lineageOSVersion) has not been added to the database yet. Edit the tools/android_version_from_lineageos_version.dart file!");
  }
}