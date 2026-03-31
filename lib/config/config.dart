import 'dart:io';
import 'package:flutter/foundation.dart';

class Config {
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:8000/api";
    } else if (Platform.isAndroid) {
      return "http://10.0.2.2:8000/api";
    } else if (Platform.isIOS) {
      return "http://localhost:8000/api";
    } else {
      return "http://localhost:8000/api";
    }
  }
}