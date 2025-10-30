import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loomeive/loomeive.dart';
import 'package:miss_minutes/ui/shared/root.page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:miss_minutes/utilities/theme.utility.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(
    LoomeiveLocalization.build(
      supportedLocales: [
        Locale('en', 'GB'),
        Locale('it', 'IT'),
        Locale('en', 'US'),
      ],
      fallbackLocale: Locale(Platform.localeName),
      additionalPaths: ['assets/translations'],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        ...context.localizationDelegates,
        FormBuilderLocalizations.delegate,
      ],
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: ThemedStatusBar(child: RootPage()),
    );
  }
}
