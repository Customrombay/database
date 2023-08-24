String extendedCodenameCreator({
    required String readCodename,
    required String readVendor
  }) {
  readVendor = readVendor.toLowerCase();
  if ((readCodename == "twolip" || readCodename == "tulip") && (readVendor == "xiaomi" || readVendor == "redmi")) {
    return "xiaomi-tulip";
  }
  else if (readCodename == "apollon" && readVendor == "xiaomi") {
    return "xiaomi-apollo";
  }
  // else if ((readCodename == "mi439" || readCodename == "Mi439" || readCodename == "olives") && (readVendor == "xiaomi" || readVendor == "redmi")) {
  //   return "xiaomi-olives";
  // }
  else if ((readCodename == "mi439" || readCodename == "Mi439" || readCodename == "olives" || readCodename == "riva" || readCodename == "rova") && (readVendor == "xiaomi" || readVendor == "redmi")) {
    return "xiaomi-Mi439";
  }
  else if ((readCodename == "lime" || readCodename == "citrus") && (readVendor == "xiaomi" || readVendor == "redmi")) {
    return "xiaomi-juice";
  }
  else if (readCodename == "mojito" && readVendor == "redmi") {
    return "xiaomi-mojito";
  }
  else if (readCodename == "begonia" && readVendor == "redmi") {
    return "xiaomi-begonia";
  }
  else if (readCodename == "ginkgo" && readVendor == "redmi") {
    return "xiaomi-ginkgo";
  }
  else if (readCodename == "lavender" && readVendor == "redmi") {
    return "xiaomi-lavender";
  }
  else if (readCodename == "lancelot" && readVendor == "redmi") {
    return "xiaomi-lancelot";
  }
  else if (readCodename == "miatoll" && readVendor == "redmi") {
    return "xiaomi-miatoll";
  }
  else if (readCodename == "mido" && readVendor == "redmi") {
    return "xiaomi-mido";
  }
  else if (readCodename == "raphael" && readVendor == "redmi") {
    return "xiaomi-raphael";
  }
  else if (readCodename == "rosy" && readVendor == "redmi") {
    return "xiaomi-rosy";
  }
  else if (readCodename == "rova" && readVendor == "redmi") {
    return "xiaomi-rova";
  }
  else if (readCodename == "sakura" && readVendor == "redmi") {
    return "xiaomi-sakura";
  }
  else if (readCodename == "santoni" && readVendor == "redmi") {
    return "xiaomi-santoni";
  }
  else if (readCodename == "vince" && readVendor == "redmi") {
    return "xiaomi-vince";
  }
  else if (readCodename == "violet" && readVendor == "redmi") {
    return "xiaomi-violet";
  }
  else if (readCodename == "whyred" && readVendor == "redmi") {
    return "xiaomi-whyred";
  }
  else if (readCodename == "lava" && readVendor == "redmi") {
    return "xiaomi-lava";
  }
  else if ((readCodename == "mi8937" || readCodename == "Mi8937") && readVendor == "redmi") {
    return "xiaomi-Mi8937";
  }
  else if ((readCodename == "mi8917" || readCodename == "Mi8917") && readVendor == "redmi") {
    return "xiaomi-Mi8917";
  }
  else if (readCodename == "olive" && readVendor == "redmi") {
    return "xiaomi-olive";
  }
  else if (readCodename == "pine" && readVendor == "redmi") {
    return "xiaomi-pine";
  }
  else if (readCodename == "ysl" && readVendor == "redmi") {
    return "xiaomi-ysl";
  }
  else if (readCodename == "spes" && readVendor == "redmi") {
    return "xiaomi-spes";
  }
  else if (readCodename == "picasso" && readVendor == "redmi") {
    return "xiaomi-picasso";
  }
  else if (readCodename == "sweet" && readVendor == "redmi") {
    return "xiaomi-sweet";
  }
  else if (readCodename == "merlinx" && (readVendor == "xiaomi" || readVendor == "redmi")) {
    return "xiaomi-merlin";
  }
  else if (readCodename == "lmi" && (readVendor == "redmi" || readVendor == "poco")) {
    return "xiaomi-lmi";
  }
  else if (readCodename == "phoenix" && (readVendor == "redmi" || readVendor == "poco")) {
    return "xiaomi-phoenix";
  }
  else if (readCodename == "beryllium" && readVendor == "poco") {
    return "xiaomi-beryllium";
  }
  else if (readCodename == "alioth" && readVendor == "poco") {
    return "xiaomi-alioth";
  }
  else if (readCodename == "vayu" && readVendor == "poco") {
    return "xiaomi-vayu";
  }
  else if (readCodename == "veux" && (readVendor == "poco" || readVendor == "redmi")) {
    return "xiaomi-veux";
  }
  else if (readCodename == "munch" && readVendor == "poco") {
    return "xiaomi-munch";
  }
  else if (readCodename == "redwood" && readVendor == "poco") {
    return "xiaomi-redwood";
  }
  else if (readCodename == "fleur" && readVendor == "poco") {
    return "xiaomi-fleur";
  }
  else if (readCodename == "marble" && readVendor == "poco") {
    return "xiaomi-marble";
  }
  else if (readCodename == "camellia" && (readVendor == "redmi" || readVendor == "poco")) {
    return "xiaomi-camellia";
  }

  // See xiaomi-surya description
  else if (readCodename == "surya" && readVendor == "poco") {
    return "xiaomi-surya";
  }
  else if (readCodename == "karna" && readVendor == "poco") {
    return "xiaomi-surya";
  }
  else if (readCodename == "lemonkebab" && readVendor == "oneplus") {
    return "oneplus-lemonades";
  }
  else if (readCodename == "z2_plus" && readVendor == "lenovo") {
    return "zuk-z2_plus";
  }
  else if (readCodename == "z2_row" && readVendor == "lenovo") {
    return "zuk-z2_row";
  }
  else if (readCodename == "G" && readVendor == "10or") {
    return "10.or-G";
  }
  else if ((readCodename == "X2" || readCodename == "RMX199X") && readVendor == "realme") {
    return "realme-x2";
  }
  else if (readCodename == "X00T" && readVendor == "asus") {
    return "asus-X00TD";
  }
  else if (readVendor == "moto") {
    return "motorola-$readCodename";
  }

  else if (readCodename == "RMX1801" && readVendor == "oppo") {
    return "realme-RMX1801";
  }

  else if (readCodename == "spartan" && readVendor == "realme") {
    return "realme-RMX3371";
  }

  else if (readVendor == "banana pi") {
    return "bananapi-$readCodename";
  }

  else if (readVendor == "pine64" && readCodename == "pinephone-pro") {
    return "pine64-pinephonepro";
  }

  else if (readVendor == "raspberry" && readCodename == "rpi") {
    return "raspberry-pi";
  }

  else if (readVendor == "samsung" && readCodename == "a505fn") {
    return "samsung-a505f";
  }

  else if (readVendor == "nothing" && readCodename == "phone1") {
    return "nothing-Spacewar";
  }

  else {
    return "$readVendor-$readCodename";
  }
}