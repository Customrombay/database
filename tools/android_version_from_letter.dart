String androidVersionFromLetter(String letter) {
  letter = letter.toLowerCase();
  if (letter == "c") {
    return "1.5";
  }
  else if (letter == "d") {
    return "1.6";
  }
  else if (letter == "e") {
    return "2";
  }
  else if (letter == "f") {
    return "2.2";
  }
  else if (letter == "g") {
    return "2.3";
  }
  else if (letter == "h") {
    return "3";
  }
  else if (letter == "i") {
    return "4";
  }
  else if (letter == "j") {
    return "4.1";
  }
  else if (letter == "k") {
    return "4.4";
  }
  else if (letter == "l") {
    return "5";
  }
  else if (letter == "m") {
    return "6";
  }
  else if (letter == "n") {
    return "7";
  }
  else if (letter == "o") {
    return "8";
  }
  else if (letter == "p") {
    return "9";
  }
  else if (letter == "q") {
    return "10";
  }
  else if (letter == "r") {
    return "1";
  }
  else if (letter == "s") {
    return "12";
  }
  else if (letter == "t") {
    return "13";
  }
  else if (letter == "u") {
    return "14";
  }
  else {
    throw Exception("This letter ($letter) is not associated with any Android version. Edit the /tools/android_version_from_letter.dart file to add it.");
  }
}