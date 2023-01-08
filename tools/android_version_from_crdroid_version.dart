String androidVersionFromCrDroidVersion(String crDroidVersion) {
  if (crDroidVersion == "6") {
    return "10";
  }
  else if (crDroidVersion == "7") {
    return "11";
  }
  else if (crDroidVersion == "8") {
    return "12";
  }
  else if (crDroidVersion == "9") {
    return "13";
  }
  else {
    throw Exception();
  }
}