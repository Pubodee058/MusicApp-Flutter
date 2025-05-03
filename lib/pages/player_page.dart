import 'package:flutter/material.dart';
import '../models/song_model.dart';
import '../services/audio_service.dart';

class PlayerPage extends StatelessWidget {
   PlayerPage({super.key});
  final AudioService _audioService = AudioService();

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
       appBar: AppBar(
        backgroundColor: Colors.blueAccent,
      title: ValueListenableBuilder<SongModel?>(
        valueListenable: _audioService.currentSong,
        builder: (_, song, __) =>
          Text(song?.title ?? 'Now Playing',style: TextStyle(color: Colors.white),),
      ),
      automaticallyImplyLeading: true,
    ),
      body: ValueListenableBuilder<SongModel?>(
        valueListenable: _audioService.currentSong,
        builder: (_, song, __) {
          if (song == null) return const SizedBox.shrink();
          return Column(
            children: [
              Hero(
                tag: 'player-hero',
                child: Image.asset(
                  song.coverPath,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(song.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white)),
              Text(song.artist, style: const TextStyle(fontSize: 18, color: Colors.white)),
              const SizedBox(height: 24),
              ValueListenableBuilder<Duration>(
                valueListenable: _audioService.position,
                builder: (_, position, __) {
                  return Slider(
                    min: 0.0,
                    max: _audioService.duration.value.inSeconds.toDouble(),
                    value: position.inSeconds
                        .toDouble()
                        .clamp(0.0, _audioService.duration.value.inSeconds.toDouble()),
                    onChanged: (newValue) {
                      final seekPos = Duration(seconds: newValue.toInt());
                      _audioService.seek(seekPos);
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ValueListenableBuilder<Duration>(
                      valueListenable: _audioService.position,
                      builder: (_, pos, __) => Text(_formatDuration(pos)),
                    ),
                    ValueListenableBuilder<Duration>(
                      valueListenable: _audioService.duration,
                      builder: (_, dur, __) => Text(_formatDuration(dur)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous, size: 36),
                    onPressed: _audioService.playPrevious,
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _audioService.isPlaying,
                    builder: (_, playing, __) => IconButton(
                      iconSize: 56,
                      icon: Icon(playing ? Icons.pause_circle : Icons.play_circle),
                      onPressed: _audioService.togglePlayPause,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next, size: 36),
                    onPressed: _audioService.playNext,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Up Next', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                child: ValueListenableBuilder<List<SongModel>>(
                  valueListenable: _audioService.playlist,
                  builder: (_, list, __) {
                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (_, i) {
                        final s = list[i];
                        return ListTile(
                          selected: i == _audioService.currentIndex,
                          leading: Image.asset(s.coverPath, width: 40, fit: BoxFit.cover),
                          title: Text(s.title,style: TextStyle(color: Colors.white),),
                          subtitle: Text(s.artist,style: TextStyle(color: Colors.white)),
                          onTap: () => _audioService.playSongList(list, i),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
