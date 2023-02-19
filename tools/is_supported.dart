import 'dart:io';

bool isSupported({
  required String extendedCodename
}) {
  if (File("database/phone_data/$extendedCodename.yaml").existsSync()) {
    return true;
  }
  return false;
}