import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:miss_minutes/bloc/shifts/shifts.bloc.dart';
import 'package:miss_minutes/bloc/shifts/shifts.event.dart';
import 'package:miss_minutes/utilities/themestatus.widget.dart';
import 'package:miss_minutes/ui/shared/root.page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:miss_minutes/utilities/theme.utility.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('it'),
        Locale('en')
      ],
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      locale: Locale('it'),
      home: ThemedStatusBar(
        child: BlocProvider(
          create: (context) => ShiftBloc()..add(LoadShifts()),
          child: RootPage(),
        ),
      ),
    );
  }
}