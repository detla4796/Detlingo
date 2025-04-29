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
  bool isPlaying = false;
  int currentTrackIndex = 0;
  double volume = 1;

  final List<String> tracks = [
    'audio/rain.mp3',
    'audio/forest.mp3',
    'audio/ocean.mp3',
  ];

  @override
  void initState() {
    super.initState();
    playAudio();
    audioPlayer.setVolume(volume);
  }

  void playAudio() async {
    await audioPlayer.setAsset(tracks[currentTrackIndex]);
  }

  void changeTrack() {
    setState(() {
      currentTrackIndex = (currentTrackIndex + 1) % tracks.length;
      playAudio();
      if (isPlaying) {
        audioPlayer.play();
      }
    });
  }

  void previousTrack() {
    setState(() {
      currentTrackIndex = (currentTrackIndex - 1) % tracks.length;
      playAudio();
      if (isPlaying) {
        audioPlayer.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    bool isDark = theme.themeMode == ThemeMode.dark;
    final locale = Provider.of<LocaleProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settings),
        ),
        body: Column(
          children: [
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.theme),
              subtitle: Text(AppLocalizations.of(context)!.themeSubtitle),
              value: isDark,
              onChanged: (value) {
                setState(() {
                  isDark = value;
                  theme.toggleTheme(isDark);
                });
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                locale.toggleLocale();
              },
              child: Text(AppLocalizations.of(context)!.language),
            ),
            SizedBox(height: 10),
            Text(AppLocalizations.of(context)!.music),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: previousTrack,
                  icon: Icon(Icons.skip_previous),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      audioPlayer.play();
                      isPlaying = true;
                    });
                  },
                  child: Text(AppLocalizations.of(context)!.musicPlay),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      audioPlayer.pause();
                      isPlaying = false;
                    });
                  },
                  child: Text(AppLocalizations.of(context)!.musicPause),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      audioPlayer.stop();
                      isPlaying = false;
                    });
                  },
                  child: Text(AppLocalizations.of(context)!.musicStop),
                ),
                SizedBox(width: 10),
                IconButton(
                  onPressed: changeTrack,
                  icon: Icon(Icons.skip_next),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [ 
                  Icon(Icons.volume_down),
                  Expanded(
                    child: Slider(
                      value: volume,
                      min: 0,
                      max: 1,
                      onChanged: (value) {
                        setState(() {
                          volume = value;
                          audioPlayer.setVolume(volume);
                        });
                      },
                    ),
                  ),
                  Icon(Icons.volume_up),
                ],
              )
            ),
          ],
        ),
    );
  }
}