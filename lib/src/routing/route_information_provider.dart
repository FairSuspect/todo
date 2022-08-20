import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class DebugRouteInformationProvider extends PlatformRouteInformationProvider {
  DebugRouteInformationProvider()
      : super(
            initialRouteInformation: RouteInformation(
                location: PlatformDispatcher.instance.defaultRouteName));

  @override
  Future<bool> didPushRoute(String route) {
    Logger("Navigation").log(Level.INFO, 'Platform reports $route');
    // TODO: Put analytics here
    return super.didPushRoute(route);
  }
}
