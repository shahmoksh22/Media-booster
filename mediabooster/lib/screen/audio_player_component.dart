import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:ui';

class AudioPlayerComponent extends StatefulWidget {
  const AudioPlayerComponent({super.key});

  @override
  State<AudioPlayerComponent> createState() => _AudioPlayerComponentState();
}

class _AudioPlayerComponentState extends State<AudioPlayerComponent> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _totalDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;
  int _currentIndex = 0;
  bool _isPlaying = false;

  final List<Map<String, String>> _songs = [
    {"path": "audio/tuhai.mp3", "name": "Tu Hai"},
    {"path": "audio/tu_jaana_na_piya_king.mp3", "name": "Tu Jaana Na Piya"},
    {"path": "audio/tu_hai_kahan.mp3", "name": "Tu Hai Kahan"},
  ];

  @override
  void initState() {
    super.initState();
    _initializeAudioPlayer();
  }

  void _initializeAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _totalDuration = duration);
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() => _currentPosition = position);
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        _currentPosition = Duration.zero;
      });
    });
  }

  Future<void> _playSong(int index) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setSource(AssetSource(_songs[index]["path"]!));
      await _audioPlayer.resume();

      setState(() {
        _currentIndex = index;
        _isPlaying = true;
        _currentPosition = Duration.zero; // Reset playback position
      });
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  void _playNext() {
    if (_currentIndex < _songs.length - 1) {
      _playSong(_currentIndex + 1);
    }
  }

  void _playPrevious() {
    if (_currentIndex > 0) {
      _playSong(_currentIndex - 1);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio player"),
        elevation: 5,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              // Glassmorphism Background
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7), // Light Background
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Now Playing",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Black Text
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Song Name
                        Text(
                          _songs[_currentIndex]["name"]!,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black87, // Darker Black for better contrast
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Progress Bar
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            LinearProgressIndicator(
                              minHeight: 15,
                              value: _currentPosition.inSeconds /
                                  (_totalDuration.inSeconds == 0
                                      ? 1
                                      : _totalDuration.inSeconds),
                              backgroundColor: Colors.black12,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.blueAccent),
                            ),
                            Positioned(
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  "${_currentPosition.toString().split(".")[0]} / ${_totalDuration.toString().split(".")[0]}",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Playback Controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildControlButton(Icons.skip_previous, _playPrevious,
                                Colors.black),
                            _buildPlayPauseButton(),
                            _buildControlButton(
                                Icons.skip_next, _playNext, Colors.black),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Circular Play/Pause Button
  Widget _buildPlayPauseButton() {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent,
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 15,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          _isPlaying ? Icons.pause : Icons.play_arrow,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  // Small Buttons (Previous & Next)
  Widget _buildControlButton(IconData icon, VoidCallback onPressed, Color color) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, size: 30, color: color),
      ),
    );
  }
}