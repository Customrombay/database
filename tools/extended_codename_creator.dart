String extendedCodenameCreator({
    required String readCodename,
    required String vendor
  }) {
  if ((readCodename == "twolip" || readCodename == "tulip") && (vendor == "Xiaomi" || vendor == "Redmi")) {
    return "xiaomi-tulip";
  }
  else if (readCodename == "apollon" && vendor == "Xiaomi") {
    return "xiaomi-apollo";
  }
  else if ((readCodename == "mi439" || readCodename == "Mi439" || readCodename == "olives") && (vendor == "Xiaomi" || vendor == "Redmi")) {
    return "xiaomi-olives";
  }
  else if (readCodename == "mojito" && vendor == "Redmi") {
    return "xiaomi-mojito";
  }
  else if (readCodename == "begonia" && vendor == "Redmi") {
    return "xiaomi-begonia";
  }
  else if (readCodename == "ginkgo" && vendor == "Redmi") {
    return "xiaomi-ginkgo";
  }
  else if (readCodename == "lavender" && vendor == "Redmi") {
    return "xiaomi-lavender";
  }
  else if (readCodename == "miatoll" && vendor == "Redmi") {
    return "xiaomi-miatoll";
  }
  else if (readCodename == "mido" && vendor == "Redmi") {
    return "xiaomi-mido";
  }
  else if (readCodename == "raphael" && vendor == "Redmi") {
    return "xiaomi-raphael";
  }
  else if (readCodename == "rosy" && vendor == "Redmi") {
    return "xiaomi-rosy";
  }
  else if (readCodename == "rova" && vendor == "Redmi") {
    return "xiaomi-rova";
  }
  else if (readCodename == "sakura" && vendor == "Redmi") {
    return "xiaomi-sakura";
  }
  else if (readCodename == "santoni" && vendor == "Redmi") {
    return "xiaomi-santoni";
  }
  else if (readCodename == "vince" && vendor == "Redmi") {
    return "xiaomi-vince";
  }
  else if (readCodename == "violet" && vendor == "Redmi") {
    return "xiaomi-violet";
  }
  else if (readCodename == "whyred" && vendor == "Redmi") {
    return "xiaomi-whyred";
  }
  else if (readCodename == "lava" && vendor == "Redmi") {
    return "xiaomi-lava";
  }
  else if (readCodename == "mi8937" && vendor == "Redmi") {
    return "xiaomi-mi8937";
  }
  else if (readCodename == "olive" && vendor == "Redmi") {
    return "xiaomi-olive";
  }
  else if (readCodename == "pine" && vendor == "Redmi") {
    return "xiaomi-pine";
  }
  else if (readCodename == "ysl" && vendor == "Redmi") {
    return "xiaomi-ysl";
  }
  else if (readCodename == "spes" && vendor == "Redmi") {
    return "xiaomi-spes";
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
  else if (readCodename == "beryllium" && (vendor == "Poco" || vendor == "POCO")) {
    return "xiaomi-beryllium";
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
  else if (readCodename == "X2" && vendor == "Realme") {
    return "realme-x2";
  }
  else {
    return "${vendor.toLowerCase()}-$readCodename";
  }
}