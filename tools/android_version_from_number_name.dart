int androidVersionFromNumberName({
  required String androidVersionNumberName
}) {
  if (androidVersionNumberName == "fourteen") {
    return 14;
  }
  else if (androidVersionNumberName == "thirteen") {
    return 13;
  }
  else if (androidVersionNumberName == "twelve") {
    return 12;
  }
  else if (androidVersionNumberName == "eleven") {
    return 11;
  }
  else if (androidVersionNumberName == "ten") {
    return 10;
  }
  else {
    throw Exception("This version of Android ($androidVersionNumberName) is not supported yet.");
  }
}
