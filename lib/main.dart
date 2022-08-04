import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/src/misc/dotenv.dart';
import 'package:todo/src/misc/theme/theme.dart';
import 'package:todo/src/services/firebase.dart';
import 'package:todo/src/services/navigation.dart';
import 'package:todo/src/services/scaffold_messenger_serivce.dart';
import 'package:todo/src/services/todo_service.dart';
import 'package:todo/src/view/todo_list_controller.dart';
import 'package:todo/src/view/todo_list_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid || Platform.isIOS) {
    await FirebaseService.init();
  }

  await Dotenv().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    late final Color? importanceColor;
    if (Platform.isAndroid || Platform.isIOS) {
      importanceColor = FirebaseService.fetchImportanceColor();
    } else {
      importanceColor = null;
    }
    return MaterialApp(
        navigatorKey: Navigation().key,
        scaffoldMessengerKey: ScaffoldMessengerService().scaffoldMessengerKey,
        // colorScheme: ColorScheme.fromSeed(
        //     seedColor: Color(int.parse(
        //         FirebaseRemoteConfig.instance.getString("importance_color")))),
        theme: lightTheme.copyWith(extensions: [
          customColorsLight.copyWith(red: importanceColor),
          layoutColorsLight
        ]),
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        onGenerateTitle: (context) => AppLocalizations.of(context).title,
        locale: Locale("ru", "RU"),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ru', 'RU'),
        ],
        home: ChangeNotifierProvider(
          create: (_) => TodoListController(TodoService()),
          child: const TodoListScreen(),
        ));
  }
}
