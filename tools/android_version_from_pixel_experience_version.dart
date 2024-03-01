int androidVersionFromPixelExperienceVersion({
  required String pixelExperienceVersion
}) {
  if (pixelExperienceVersion == "fourteen" || pixelExperienceVersion == "fourteen_plus") {
    return 14;
  }
  else if (pixelExperienceVersion == "thirteen" || pixelExperienceVersion == "thirteen_plus") {
    return 13;
  }
  else if (pixelExperienceVersion == "twelve" || pixelExperienceVersion == "twelve_plus") {
    return 12;
  }
  else if (pixelExperienceVersion == "eleven" || pixelExperienceVersion == "eleven_plus") {
    return 11;
  }
  else {
    throw Exception("This version of PixelExperience ($pixelExperienceVersion) is not supported yet.");
  }
}