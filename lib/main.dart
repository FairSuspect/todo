import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/src/misc/dotenv.dart';
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
  if (Platform.isAndroid || Platform.isIOS) await FirebaseService.init();

  await Dotenv().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        navigatorKey: Navigation().key,
        scaffoldMessengerKey: ScaffoldMessengerService().scaffoldMessengerKey,
        theme: ThemeData(checkboxTheme: const CheckboxThemeData()
            // colorScheme: ColorScheme.fromSeed(
            //     seedColor: Color(int.parse(
            //         FirebaseRemoteConfig.instance.getString("importance_color")))),
            ),
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
