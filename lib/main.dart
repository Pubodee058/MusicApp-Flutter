import 'package:flutter/material.dart';
import 'pages/song_list_page.dart';

void main() {
  runApp(const MusicApp());
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      home: SongListPage(),
    );
  }
}
