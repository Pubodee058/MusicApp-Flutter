import 'package:flutter/material.dart';
import '../models/song_model.dart';
import '../services/audio_service.dart';
import 'player_page.dart';

class SongListPage extends StatefulWidget {
  const SongListPage({super.key});

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  final List<SongModel> _songs = [
    SongModel(
      title: 'hearty',
      artist: 'hearty',
      path: 'assets/audio/hearty.mp3',
      coverPath: 'assets/images/hearty_cover.jpg',
    ),
    SongModel(
      title: 'rhythmmagnet',
      artist: 'rhythm',
      path: 'assets/audio/rhythmmagnet.mp3',
      coverPath: 'assets/images/rhythmmagnet_cover.jpg',
    ),
  ];

  final AudioService _audioService = AudioService();

  /// เมื่อผู้ใช้แตะเพลงในลิสต์
  void _selectSong(int index) async {
    await _audioService.playSongList(_songs, index);
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => PlayerPage(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Playlist', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold))),
      body: ListView.builder(
        itemCount: _songs.length,
        itemBuilder: (_, index) {
          final song = _songs[index];
          return ListTile(
            leading: Image.asset(song.coverPath, width: 50, height: 50, fit: BoxFit.cover),
            title: Text(song.title),
            subtitle: Text(song.artist),
            onTap: () => _selectSong(index),
            trailing: Icon(Icons.play_arrow_rounded),
          );
        },
      ),
      bottomNavigationBar: ValueListenableBuilder<SongModel?>(
        valueListenable: _audioService.currentSong,
        builder: (_, song, __) {
          if (song == null) return const SizedBox.shrink();
          return GestureDetector(
            onTap: () => _selectSong(_audioService.currentIndex),
            child: Hero(
              tag: 'player-hero',
              child: Container(
                height: 70,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26)],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Image.asset(song.coverPath, width: 50, height: 50, fit: BoxFit.cover),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(song.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(song.artist, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _audioService.isPlaying,
                      builder: (_, playing, __) {
                        return IconButton(
                          icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                          onPressed: _audioService.togglePlayPause,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
