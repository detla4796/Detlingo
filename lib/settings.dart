import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lessons_app/generated/s.dart';
import 'package:provider/provider.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  void toggleTheme(isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class LocaleProvider with ChangeNotifier {
  Locale _locale = Locale('en');
  Locale get locale => _locale;

  void toggleLocale() {
    _locale = _locale.languageCode == 'en' ? Locale('ru') : Locale('en');
    notifyListeners();
  }
}

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool _isMusicEnabled = false;

  @override
  void initState() {
    super.initState();
    playAudio();
  }

  Future<void> playAudio() async {
    await audioPlayer.setAsset('audio/rain.mp3');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    bool isDark = theme.themeMode == ThemeMode.dark;
    final locale = Provider.of<LocaleProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Column(
          children: [
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.music),
              subtitle: Text('Enable music'),
              value: _isMusicEnabled,
              onChanged: (value) {
                setState(() {
                  _isMusicEnabled = value;
                  if (_isMusicEnabled) {
                    audioPlayer.play();
                  } 
                  else {
                    audioPlayer.pause();
                  }
                });
              },
            ),
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.theme),
              subtitle: Text('Enable dark theme'),
              value: isDark,
              onChanged: (value) {
                setState(() {
                  isDark = value;
                  theme.toggleTheme(isDark);
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                locale.toggleLocale();
              },
              child: Text(AppLocalizations.of(context)!.language),
            ),
          ],
        ),
    );
  }
}