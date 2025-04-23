import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'menu.dart';
import 'settings.dart';
import 'generated/s.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeMode;
    final locale = Provider.of<LocaleProvider>(context).locale;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Language Learning App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: theme,
      locale: locale,
      supportedLocales: [Locale('en'), Locale('ru')],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: MenuScreen(),
    );
  }
}
