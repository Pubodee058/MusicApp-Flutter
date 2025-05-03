import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/song_model.dart';

class AudioService {
  // Singleton
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal() {
    _player = AudioPlayer();

    // Listen events
    _player.onDurationChanged.listen((d) {
      duration.value = d;
    });
    _player.onPositionChanged.listen((p) {
      position.value = p;
    });
    _player.onPlayerComplete.listen((_) => playNext());

    // Init notifiers
    currentSong = ValueNotifier<SongModel?>(null);
    isPlaying   = ValueNotifier<bool>(false);
    duration    = ValueNotifier<Duration>(Duration.zero);
    position    = ValueNotifier<Duration>(Duration.zero);
    playlist    = ValueNotifier<List<SongModel>>([]);
  }

  late final AudioPlayer _player;

  // Notifiers for UI binding
  late final ValueNotifier<SongModel?>      currentSong;
  late final ValueNotifier<bool>            isPlaying;
  late final ValueNotifier<Duration>        duration;
  late final ValueNotifier<Duration>        position;
  late final ValueNotifier<List<SongModel>> playlist;

  // Internal state
  List<SongModel> _songs = [];
  int currentIndex = 0;


Future<void> playSongList(List<SongModel> list, int index) async {
  _songs = List.from(list);
  playlist.value = List.unmodifiable(list);
  currentIndex = index;
  await _playCurrent();
}


  Future<void> _playCurrent() async {
    final song = _songs[currentIndex];
    currentSong.value = song;

    // โหลด asset หรือ file จาก device
    final path = song.path;
    if (path.startsWith('assets/audio/')) {
      final assetPath = path.replaceFirst('assets/', '');
      await _player.setSource(AssetSource(assetPath));
    } else {
      await _player.setSource(DeviceFileSource(path));
    }

    await _player.resume();
    isPlaying.value = true;
  }

  Future<void> seek(Duration pos) async {
    await _player.seek(pos);
    position.value = pos;
  }

  void togglePlayPause() {
    if (isPlaying.value) {
      _player.pause();
      isPlaying.value = false;
    } else {
      _player.resume();
      isPlaying.value = true;
    }
  }

  void playNext() {
    if (currentIndex + 1 < playlist.value.length) {
      currentIndex++;
      _playCurrent();
    }
  }

  void playPrevious() {
    if (currentIndex - 1 >= 0) {
      currentIndex--;
      _playCurrent();
    }
  }
}
