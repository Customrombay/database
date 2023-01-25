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
  else if (readCodename == "merlinx" && vendor == "Xiaomi") {
    return "xiaomi-merlin";
  }
  else if (readCodename == "alioth" && (vendor == "Poco" || vendor == "POCO")) {
    return "xiaomi-alioth";
  }
  else if (readCodename == "vayu" && (vendor == "Poco" || vendor == "POCO")) {
    return "xiaomi-vayu";
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
  else {
    return "${vendor.toLowerCase()}-$readCodename";
  }
}