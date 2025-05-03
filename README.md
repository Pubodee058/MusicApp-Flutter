# Flutter Music Player Test Submission

Thank you for the opportunity to complete this technical exercise. Below you’ll find a concise overview of the solution, instructions to run the app, and a few notes on design decisions.

---

## 🚀 Features Implemented

1. **Local‐Asset Playback**  
   - Bundled MP3 files (`assets/audio/`) and album covers (`assets/images/`)  
   - No external API calls—everything runs offline

2. **Playlist & “Up Next”**  
   - SongListPage shows all tracks  
   - PlayerPage displays current track, position slider, and upcoming queue  

3. **Persistent Mini‐Player**  
   - Bottom bar appears after you select a track  
   - Shows cover art, title, artist, and play/pause toggle  
   - Tap to expand into full-screen PlayerPage with a Hero animation

4. **Core Controls**  
   - Play, Pause, Skip Previous / Next  
   - Scrub via slider; real-time duration and position labels  
   - Tracks completion and auto-advances to the next song

5. **Clean Architecture**  
   - **`AudioService`** singleton encapsulates all audio logic  
   - UI layers (`SongListPage` and `PlayerPage`) simply bind to `ValueNotifier`s  

---

## 📂 Project Structure

/assets
/audio ← MP3 tracks
/images ← Cover art
/lib
/models ← SongModel data class
/services ← AudioService singleton (play, pause, seek, playlist state)
/pages
song_list_page.dart ← Select & queue tracks
player_page.dart ← Full-screen player UI
pubspec.yaml ← Dependency & asset definitions
README.md ← This file

