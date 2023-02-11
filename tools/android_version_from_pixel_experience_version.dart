int androidVersionFromPixelExperienceVersion({
  required String pixelExperienceVersion
}) {
  if (pixelExperienceVersion == "thirteen" || pixelExperienceVersion == "thirteen_plus") {
    return 13;
  }
  else if (pixelExperienceVersion == "twelve" || pixelExperienceVersion == "twelve_plus") {
    return 12;
  }
  else if (pixelExperienceVersion == "eleven" || pixelExperienceVersion == "eleven_plus") {
    return 11;
  }
  else {
    throw Exception("This version of EvolutionX ($pixelExperienceVersion) is not supported yet.");
  }
}