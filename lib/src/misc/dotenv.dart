import 'package:flutter_dotenv/flutter_dotenv.dart';

class Dotenv {
  static final _env = Dotenv._();
  factory Dotenv() => _env;
  Dotenv._();
  Future<void> init() => dotenv.load(fileName: ".env");

  String getValue(String key) {
    return dotenv.get(key);
  }
}
