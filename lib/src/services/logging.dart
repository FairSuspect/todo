import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

void initLogger() {
  Logger.root.level = kDebugMode ? Level.ALL : Level.CONFIG;
  Logger.root.onRecord.listen((record) {
    print(
        '[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
  });
}
