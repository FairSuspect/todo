import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todo/src/services/firebase/analytics.dart';

class AnalyticsRouteInformationProvider
    extends PlatformRouteInformationProvider {
  AnalyticsRouteInformationProvider()
      : super(
            initialRouteInformation: RouteInformation(
                location: PlatformDispatcher.instance.defaultRouteName));

  @override
  Future<bool> didPushRoute(String route) {
    Analytics.logScreenView(route);
    return super.didPushRoute(route);
  }
}
