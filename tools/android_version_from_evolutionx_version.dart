String androidVersionFromEvolutionXVersion({
  required String evolutionXVersion
}) {
  if (evolutionXVersion == "thirteen") {
    return "13";
  }
  else if (evolutionXVersion == "twelve") {
    return "12";
  }
  else if (evolutionXVersion == "eleven") {
    return "11";
  }
  else {
    throw Exception("This version of EvolutionX ($evolutionXVersion) is not supported yet.");
  }
}