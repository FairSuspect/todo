import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/src/misc/dotenv.dart';
import 'package:todo/src/misc/theme/theme.dart';
import 'package:todo/src/routing/deletage.dart';
import 'package:todo/src/routing/route_information_provider.dart';
import 'package:todo/src/services/firebase/firebase.dart';
import 'package:todo/src/services/scaffold_messenger_serivce.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'src/routing/parser.dart';
import 'src/services/logging.dart' as logger;

import 'src/models/todo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  logger.initLogger();

  if (Platform.isAndroid || Platform.isIOS) {
    await FirebaseService.init();
  }

  final hivePath = (await getApplicationSupportDirectory()).path;

  Hive
    ..init(hivePath)
    ..registerAdapter(TodoAdapter())
    ..registerAdapter(ImportanceAdapter());

  await Dotenv().init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final Color? importanceColor;

    if (Platform.isAndroid || Platform.isIOS) {
      importanceColor = FirebaseService.fetchImportanceColor();
    } else {
      importanceColor = null;
    }
    return MaterialApp.router(
      routeInformationParser: TodoRouteParser(),
      routerDelegate: TodoRouterDelegate(),
      routeInformationProvider: AnalyticsRouteInformationProvider(),
      scaffoldMessengerKey: ScaffoldMessengerService().scaffoldMessengerKey,
      // colorScheme: ColorScheme.fromSeed(
      //     seedColor: Color(int.parse(
      //         FirebaseRemoteConfig.instance.getString("importance_color")))),
      theme: lightTheme.copyWith(extensions: [
        customColorsLight.copyWith(red: importanceColor),
        layoutColorsLight
      ]),
      darkTheme: darkTheme.copyWith(extensions: [
        customColorsDark.copyWith(red: importanceColor),
        layoutColorsDark
      ]),
      themeMode: ThemeMode.system,
      onGenerateTitle: (context) => AppLocalizations.of(context).title,
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
      // home: ChangeNotifierProvider<TodoListBaseController>(
      //   create: (_) => TodoListController(TodoService(), HiveService()),
      //   child: const TodoListScreen(),
      // ),
    );
  }
}
