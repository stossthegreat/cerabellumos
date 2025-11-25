import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import '../companion/companion_controller.dart';

/// Audio Service - Handles TTS playback and companion animation
/// 
/// Manages audio playback from base64 data and syncs with companion animations.
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  /// Play audio from base64 and animate companion
  Future<void> playVoiceMessage({
    required String audioBase64,
    required String text,
    required CompanionController companion,
  }) async {
    if (_isPlaying) {
      print('🎤 Audio already playing, skipping...');
      return;
    }

    try {
      _isPlaying = true;
      print('🎤 Playing voice message: "${text.substring(0, 50)}..."');

      // Decode base64 to bytes
      final bytes = base64Decode(audioBase64);

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/companion_voice_${DateTime.now().millisecondsSinceEpoch}.mp3');
      await tempFile.writeAsBytes(bytes);

      // Start companion talking animation
      companion.startTalking();

      // Play audio
      await _player.play(DeviceFileSource(tempFile.path));

      // Wait for playback to complete
      await _player.onPlayerComplete.first;

      // Stop talking animation
      companion.stopTalking();

      // Clean up temp file
      try {
        await tempFile.delete();
      } catch (e) {
        print('⚠️ Failed to delete temp audio file: $e');
      }

      _isPlaying = false;
      print('✅ Voice message playback complete');
    } catch (e) {
      _isPlaying = false;
      print('❌ Error playing voice message: $e');
      // Still trigger talk animation even if audio fails (visual feedback)
      companion.startTalking();
      await Future.delayed(Duration(milliseconds: text.length * 50));
      companion.stopTalking();
    }
  }

  /// Stop current playback
  Future<void> stop() async {
    await _player.stop();
    _isPlaying = false;
  }

  /// Clean up resources
  Future<void> dispose() async {
    await _player.dispose();
  }
}

