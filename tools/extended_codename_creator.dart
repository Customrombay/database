String extendedCodenameCreator({
    required String readCodename,
    required String vendor
  }) {
  if (readCodename == "twolip" && vendor == "Xiaomi") {
    return "xiaomi-tulip";
  }
  else if (readCodename == "apollon" && vendor == "Xiaomi") {
    return "xiaomi-apollo";
  }
  else if (readCodename == "mojito" && vendor == "Redmi") {
    return "xiaomi-mojito";
  }
  else if (readCodename == "picasso" && vendor == "Redmi") {
    return "xiaomi-picasso";
  }
  else if (readCodename == "sweet" && vendor == "Redmi") {
    return "xiaomi-sweet";
  }
  else if (readCodename == "merlinx" && (vendor == "Xiaomi" || vendor == "Redmi")) {
    return "xiaomi-merlin";
  }
  else if (readCodename == "lmi" && (vendor == "Redmi" || vendor == "POCO" || vendor == "Poco")) {
    return "xiaomi-lmi";
  }
  else if (readCodename == "phoenix" && (vendor == "Redmi" || vendor == "POCO" || vendor == "Poco")) {
    return "xiaomi-phoenix";
  }
  else if (readCodename == "alioth" && (vendor == "Poco" || vendor == "POCO")) {
    return "xiaomi-alioth";
  }
  else if (readCodename == "vayu" && (vendor == "Poco" || vendor == "POCO")) {
    return "xiaomi-vayu";
  }
  else if (readCodename == "veux" && (vendor == "Poco" || vendor == "POCO")) {
    return "xiaomi-veux";
  }
  else if (readCodename == "munch" && (vendor == "Poco" || vendor == "POCO")) {
    return "xiaomi-munch";
  }

  // See xiaomi-surya description
  else if (readCodename == "surya" && (vendor == "Poco" || vendor == "POCO")) {
    return "xiaomi-surya";
  }
  else if (readCodename == "karna" && (vendor == "Poco" || vendor == "POCO")) {
    return "xiaomi-surya";
  }
  else if (readCodename == "lemonkebab" && (vendor == "Oneplus" || vendor == "OnePlus")) {
    return "oneplus-lemonades";
  }
  else if (readCodename == "z2_plus" && vendor == "Lenovo") {
    return "zuk-z2_plus";
  }

  else if (readCodename == "G" && vendor == "10or") {
    return "10.or-G";
  }
  else {
    return "${vendor.toLowerCase()}-$readCodename";
  }
}