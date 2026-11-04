import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lexi_lens/core/models/document_model.dart';
import 'package:lexi_lens/core/models/user_preferences.dart';
import 'package:lexi_lens/core/services/auth_service.dart';
import 'package:lexi_lens/core/services/ocr_service.dart';
import 'package:lexi_lens/core/services/storage_service.dart';
import 'package:lexi_lens/core/services/tts_service.dart';
import 'package:lexi_lens/core/theme/app_tokens.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Design Tokens (DESIGN.md / SKILL.md)', () {
    test('Typography tokens match exact scale', () {
      expect(AppTokens.fontSizeXs, 13.0);
      expect(AppTokens.fontSizeSm, 15.0);
      expect(AppTokens.fontSizeMd, 17.0);
      expect(AppTokens.fontSizeLg, 19.0);
      expect(AppTokens.fontSizeXl, 22.0);
      expect(AppTokens.fontSize2xl, 26.0);
      expect(AppTokens.fontSize3xl, 32.0);
      expect(AppTokens.fontSize4xl, 40.0);
    });

    test('Color tokens match palette hex values', () {
      expect(AppTokens.colorTextPrimary.toARGB32(), 0xFF211D1A);
      expect(AppTokens.colorTextSecondary.toARGB32(), 0xFF5B5349);
      expect(AppTokens.colorBgCanvas.toARGB32(), 0xFFFBF6EE);
      expect(AppTokens.colorAccentPrimary.toARGB32(), 0xFF2B6E63);
      expect(AppTokens.colorAccentWarm.toARGB32(), 0xFFE8833B);
    });

    test('Radius and spacing tokens match specifications', () {
      expect(AppTokens.radiusSm, 8.0);
      expect(AppTokens.radiusMd, 14.0);
      expect(AppTokens.radiusLg, 22.0);
      expect(AppTokens.space1, 4.0);
      expect(AppTokens.space4, 16.0);
    });
  });

  group('UserPreferences Model (DESIGN.md / SKILL.md)', () {
    test('Default preferences adhere to DESIGN.md specification', () {
      final prefs = UserPreferences.defaultPreferences('test_user');
      expect(prefs.ownerId, 'test_user');
      expect(prefs.fontFamily, 'OpenDyslexic');
      expect(prefs.fontSize, 18);
      expect(prefs.letterSpacing, 0.04);
      expect(prefs.lineSpacing, 1.6);
      expect(prefs.overlayColor, isNull);
      expect(prefs.ttsSpeed, 1.0);
    });

    test('copyWith updates fields correctly', () {
      final prefs = UserPreferences.defaultPreferences('user1');
      final updated = prefs.copyWith(
        fontSize: 22,
        letterSpacing: 0.08,
        overlayColor: 'cream',
      );

      expect(updated.fontSize, 22);
      expect(updated.letterSpacing, 0.08);
      expect(updated.overlayColor, 'cream');
      expect(updated.fontFamily, 'OpenDyslexic');
    });

    test('JSON serialization & deserialization preserves values', () {
      final original = UserPreferences(
        ownerId: 'u-123',
        fontFamily: 'Lexend',
        fontSize: 20,
        letterSpacing: 0.08,
        lineSpacing: 1.8,
        overlayColor: 'blue',
        ttsSpeed: 1.25,
        updatedAt: DateTime.parse('2026-09-24T20:00:00Z'),
      );

      final json = original.toJson();
      final reconstructed = UserPreferences.fromJson(json);

      expect(reconstructed.ownerId, original.ownerId);
      expect(reconstructed.fontFamily, original.fontFamily);
      expect(reconstructed.fontSize, original.fontSize);
      expect(reconstructed.letterSpacing, original.letterSpacing);
      expect(reconstructed.lineSpacing, original.lineSpacing);
      expect(reconstructed.overlayColor, original.overlayColor);
      expect(reconstructed.ttsSpeed, original.ttsSpeed);
    });
  });

  group('Document Model (PRD Section 6)', () {
    test('Document model serializes and preserves RLS owner_id', () {
      final doc = DocumentModel(
        id: 'doc-abc',
        ownerId: 'owner-789',
        title: 'Worksheet 1',
        rawText: 'Sample text for dyslexia readers',
        source: 'camera',
        createdAt: DateTime.parse('2026-09-24T12:00:00Z'),
        updatedAt: DateTime.parse('2026-09-24T12:00:00Z'),
        confidence: 0.97,
      );

      final json = doc.toJson();
      final parsed = DocumentModel.fromJson(json);

      expect(parsed.id, 'doc-abc');
      expect(parsed.ownerId, 'owner-789');
      expect(parsed.title, 'Worksheet 1');
      expect(parsed.source, 'camera');
      expect(parsed.confidence, 0.97);
      expect(parsed.deletedAt, isNull);
    });
  });

  group('StorageService (PRD Flow E & RLS simulation)', () {
    test('Documents are isolated by user ID and soft deleted correctly', () async {
      final storage = StorageService();

      // Initially returns seeded default documents for the user
      final initialDocs = await storage.getDocuments(userId: 'user_A');
      expect(initialDocs.isNotEmpty, isTrue);

      // Create a document for user_A
      final newDoc = DocumentModel(
        id: 'doc-1',
        ownerId: 'user_A',
        title: 'User A Document',
        rawText: 'Hello from user A',
        source: 'upload',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await storage.saveDocument(newDoc);

      final userADocs = await storage.getDocuments(userId: 'user_A');
      expect(userADocs.any((d) => d.id == 'doc-1'), isTrue);

      // User B should not see user A's doc
      final userBDocs = await storage.getDocuments(userId: 'user_B');
      expect(userBDocs.any((d) => d.id == 'doc-1'), isFalse);

      // Soft delete
      await storage.softDeleteDocument('doc-1', userId: 'user_A');
      final afterDeleteDocs = await storage.getDocuments(userId: 'user_A');
      expect(afterDeleteDocs.any((d) => d.id == 'doc-1'), isFalse);
    });
  });

  group('OcrService (PRD Section 7 & 11)', () {
    test('Rejects oversized images exceeding 10MB limit', () async {
      final ocr = OcrService();
      // 10MB + 10 bytes
      final oversizedBytes = Uint8List(10 * 1024 * 1024 + 10);

      final result = await ocr.extractText(imageBytes: oversizedBytes);
      expect(result.isSuccess, isFalse);
      expect(result.errorCode, 'file_too_large');
    });

    test('Extracts realistic educational text for presets', () async {
      final ocr = OcrService();
      final result = await ocr.extractText(sampleType: 'science');

      expect(result.isSuccess, isTrue);
      expect(result.text.contains('Photosynthesis'), isTrue);
      expect(result.confidence, greaterThan(0.9));
    });
  });

  group('TtsService (PRD Flow C)', () {
    test('Calculates word count, progress, and speed changes', () async {
      final tts = TtsService();
      expect(tts.isPlaying, isFalse);

      await tts.speak('One two three four five');
      expect(tts.words.length, 5);
      expect(tts.isPlaying, isTrue);

      tts.setSpeed(1.5);
      expect(tts.speed, 1.5);

      tts.seekToWord(2);
      expect(tts.currentWordIndex, 2);
      expect(tts.progress, closeTo(0.6, 0.01));

      tts.pause();
      expect(tts.isPaused, isTrue);

      tts.resume();
      expect(tts.isPlaying, isTrue);

      tts.stop();
      expect(tts.isPlaying, isFalse);
      tts.dispose();
    });
  });

  group('AuthService (PRD Flow D)', () {
    test('Guest session is set by default and unauthenticated', () async {
      final auth = AuthService();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(auth.isGuest, isTrue);
      expect(auth.isLoggedIn, isFalse);
    });

    test('Validates signup and creates session', () async {
      final auth = AuthService();
      final ok = await auth.signup('test@lexilens.com', 'secret123', displayName: 'Jane Doe');

      expect(ok, isTrue);
      expect(auth.isLoggedIn, isTrue);
      expect(auth.currentUser?.email, 'test@lexilens.com');
      expect(auth.currentUser?.displayName, 'Jane Doe');
    });

    test('Validates incorrect passwords during login', () async {
      final auth = AuthService();
      await auth.signup('user@example.com', 'password123');

      final failedLogin = await auth.login('user@example.com', 'wrongpassword');
      expect(failedLogin, isFalse);
      expect(auth.authError, contains('Incorrect password'));
    });
  });
}
