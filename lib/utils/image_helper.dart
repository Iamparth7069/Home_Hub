import 'dart:convert';
import 'dart:io';

class ImageHelper {
  static String fileToBase64(File file) {
    List<int> fileBytes = file.readAsBytesSync();
    String base64Image = base64Encode(fileBytes);
    return base64Image;
  }

  static File base64ToFile(String base64String, String filePath) {
    List<int> decodedBytes = base64Decode(base64String);
    File file = File(filePath);
    file.writeAsBytesSync(decodedBytes);
    return file;
  }
}
