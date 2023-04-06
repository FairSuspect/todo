import 'package:flutter/widgets.dart';

class Navigation {
  static Navigation? _instance;

  factory Navigation() => _instance ??= Navigation._();

  Navigation._();

  GlobalKey<NavigatorState> key = GlobalKey();
}
