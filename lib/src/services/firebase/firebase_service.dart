import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/rendering.dart';
import 'package:logging/logging.dart';
import 'package:todo/firebase_options.dart';
import 'package:todo/src/misc/theme/theme.dart';

class FirebaseService {
  static final _log = Logger("FirebaseService");
  static const String _importanceColorKey = "importance_color";

  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(microseconds: 1),
    ));
    final String defaultImportanceValue =
        customColorsLight.red.value.toString();
    await remoteConfig.setDefaults({
      _importanceColorKey: defaultImportanceValue,
    });
    try {
      await remoteConfig.fetchAndActivate();
    } catch (e) {
      _log.shout(e);
    }
  }

  static fetchImportanceColor() {
    final value =
        int.parse(FirebaseRemoteConfig.instance.getString(_importanceColorKey));
    return Color(value);
  }
}
