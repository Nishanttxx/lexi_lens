import 'dart:async';
import 'package:flutter/foundation.dart';

enum TtsPlaybackState { stopped, loading, playing, paused, error }

class TtsService extends ChangeNotifier {
  TtsPlaybackState _state = TtsPlaybackState.stopped;
  double _speed = 1.0;
  String _currentText = '';
  List<String> _words = [];
  int _currentWordIndex = -1;
  int _currentCharIndex = 0;
  String? _errorMessage;

  Timer? _progressionTimer;

  TtsPlaybackState get state => _state;
  double get speed => _speed;
  String get currentText => _currentText;
  List<String> get words => _words;
  int get currentWordIndex => _currentWordIndex;
  int get currentCharIndex => _currentCharIndex;
  String? get errorMessage => _errorMessage;
  bool get isPlaying => _state == TtsPlaybackState.playing;
  bool get isPaused => _state == TtsPlaybackState.paused;

  double get progress {
    if (_words.isEmpty || _currentWordIndex < 0) return 0.0;
    return ((_currentWordIndex + 1) / _words.length).clamp(0.0, 1.0);
  }

  void setSpeed(double newSpeed) {
    _speed = newSpeed;
    notifyListeners();
    if (isPlaying) {
      final targetIndex = _currentWordIndex.clamp(0, _words.length);
      _runProgression(wordOffset: targetIndex);
    }
  }

  Future<void> speak(String text, {double? speed}) async {
    if (text.trim().isEmpty) return;

    if (speed != null) _speed = speed;
    _currentText = text;
    _words = _splitIntoWords(text);
    _currentWordIndex = 0;
    _currentCharIndex = 0;
    _errorMessage = null;
    _state = TtsPlaybackState.loading;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 200));
    _state = TtsPlaybackState.playing;
    notifyListeners();

    _runProgression(wordOffset: 0);
  }

  void _runProgression({required int wordOffset}) {
    _progressionTimer?.cancel();
    _currentWordIndex = wordOffset;

    // Standard average reading speed: ~150 words per minute -> ~400ms per word
    final intervalMs = (380 / _speed).round().clamp(60, 1500);

    _progressionTimer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      if (_state != TtsPlaybackState.playing) {
        timer.cancel();
        return;
      }

      if (_currentWordIndex < _words.length - 1) {
        _currentWordIndex++;
        notifyListeners();
      } else {
        timer.cancel();
        _onSpeechCompleted();
      }
    });
  }

  void pause() {
    if (_state != TtsPlaybackState.playing) return;
    _state = TtsPlaybackState.paused;
    _progressionTimer?.cancel();
    notifyListeners();
  }

  void resume() {
    if (_state != TtsPlaybackState.paused) return;
    _state = TtsPlaybackState.playing;
    _runProgression(wordOffset: _currentWordIndex);
    notifyListeners();
  }

  void stop() {
    _progressionTimer?.cancel();
    _state = TtsPlaybackState.stopped;
    _currentWordIndex = -1;
    notifyListeners();
  }

  void seekToWord(int index) {
    if (_words.isEmpty) return;
    final targetIndex = index.clamp(0, _words.length - 1);
    _currentWordIndex = targetIndex;
    notifyListeners();

    if (isPlaying) {
      _runProgression(wordOffset: targetIndex);
    }
  }

  void _onSpeechCompleted() {
    _state = TtsPlaybackState.stopped;
    _currentWordIndex = -1;
    _progressionTimer?.cancel();
    notifyListeners();
  }

  List<String> _splitIntoWords(String text) {
    return text
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .split(' ')
        .where((w) => w.isNotEmpty)
        .toList();
  }

  @override
  void dispose() {
    _progressionTimer?.cancel();
    stop();
    super.dispose();
  }
}
