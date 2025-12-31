import 'dart:convert';
import 'dart:typed_data';

class DataFormatters {

  static Map<String, dynamic> decodeBase64ToUint8Lists(
    String? image,
  ) {
    if (image != null && image.isNotEmpty) {
      try {
        String base64String = image.trim();

        if (base64String.startsWith("b'") || base64String.startsWith('b"')) {
          base64String = base64String.substring(2, base64String.length - 1);
        }

        if (base64String.startsWith("PD94b") ||
            base64String.startsWith('<?xml') ||
            base64String.startsWith('<svg') ||
            base64String.startsWith('PHN')) {
          // SVG (XML) format
          String svgString = utf8.decode(base64Decode(base64String));

          return {'svg': svgString};
        } else {
          // PNG/JPG format
          Uint8List imageBytes = base64Decode(base64String);
          return{'memory': imageBytes};
        }
      } catch (e) {
        return {};
      }
    } else {
      return {};
    }
  }
}
