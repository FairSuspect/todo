import 'package:flutter/material.dart';

class ScaffoldMessengerService {
  static final _instance = ScaffoldMessengerService._();

  ScaffoldMessengerService._();

  factory ScaffoldMessengerService() => _instance;

  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();
}
