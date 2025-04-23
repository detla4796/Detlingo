import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool _isMusicEnabled = false;
  bool _isDarkThemeEnabled = false;

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
    return Theme(
      data: _isDarkThemeEnabled ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Column(
          children: [
            SwitchListTile(
              title: Text('Music'),
              subtitle: Text('ON/OFF music'),
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
              title: Text('Switch Theme'),
              subtitle: Text('Light/Dark theme'),
              value: _isDarkThemeEnabled,
              onChanged: (value) {
                setState(() {
                  _isDarkThemeEnabled = value;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}