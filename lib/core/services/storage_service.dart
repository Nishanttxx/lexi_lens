import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/document_model.dart';
import '../models/user_preferences.dart';

class StorageService {
  static const String _keyDocuments = 'lexi_lens_documents';
  static const String _keyPreferencesPrefix = 'lexi_lens_pref_';

  // Seed sample documents for initial experience
  static final List<DocumentModel> _defaultSeedDocuments = [
    DocumentModel(
      id: 'seed-doc-1',
      ownerId: 'default_user',
      title: 'Chapter 3: The Ocean Ecosystem',
      rawText:
          'Coral reefs are often called the rainforests of the sea. They cover less than one percent of the ocean floor, yet they support about twenty-five percent of all marine species. Corals are not plants; they are colonial animals related to jellyfish. Through a symbiotic relationship with tiny algae called zooxanthellae, corals build vast limestone structures over thousands of years. These vibrant ecosystems protect coastlines from storms, provide nurseries for fish, and offer life-saving medical discoveries.',
      source: 'upload',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      confidence: 0.98,
    ),
    DocumentModel(
      id: 'seed-doc-2',
      ownerId: 'default_user',
      title: 'Worksheet: Laws of Motion',
      rawText:
          'Isaac Newton formulated three fundamental laws of motion that describe the relationship between a body and the forces acting upon it. The first law states that an object at rest stays at rest, and an object in motion remains in motion at a constant velocity unless acted upon by a net external force. The second law establishes that force equals mass multiplied by acceleration (F = m × a). The third law reminds us that for every action, there is an equal and opposite reaction.',
      source: 'camera',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
      confidence: 0.94,
    ),
    DocumentModel(
      id: 'seed-doc-3',
      ownerId: 'default_user',
      title: 'Museum Exhibit: The Printing Press',
      rawText:
          'Johannes Gutenberg invented the movable-type printing press around 1440 in Mainz, Germany. This revolutionary breakthrough replaced laborious hand-copying of manuscripts and sparked the European Renaissance. Knowledge, literature, and scientific discoveries could now be spread widely and rapidly to people of all backgrounds.',
      source: 'camera',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 7)),
      confidence: 0.96,
    ),
  ];

  Future<List<DocumentModel>> getDocuments({required String userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString(_keyDocuments);

    List<DocumentModel> allDocs = [];
    if (rawJson != null && rawJson.isNotEmpty) {
      try {
        final List<dynamic> list = jsonDecode(rawJson) as List<dynamic>;
        allDocs = list
            .map((item) => DocumentModel.fromJson(item as Map<String, dynamic>))
            .where((doc) => doc.deletedAt == null)
            .toList();
      } catch (_) {
        allDocs = [];
      }
    }

    // Seed defaults if empty
    if (allDocs.isEmpty) {
      allDocs = _defaultSeedDocuments
          .map((d) => d.copyWith(ownerId: userId))
          .toList();
      await saveAllDocuments(allDocs);
    }

    // Filter by ownerId (RLS rule simulation: users can only see their own docs)
    return allDocs.where((doc) => doc.ownerId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<DocumentModel?> getDocumentById(String id, {required String userId}) async {
    final docs = await getDocuments(userId: userId);
    try {
      return docs.firstWhere((d) => d.id == id && d.deletedAt == null);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveDocument(DocumentModel document) async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString(_keyDocuments);
    List<DocumentModel> allDocs = [];

    if (rawJson != null && rawJson.isNotEmpty) {
      try {
        final List<dynamic> list = jsonDecode(rawJson) as List<dynamic>;
        allDocs = list
            .map((item) => DocumentModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (_) {
        allDocs = [];
      }
    }

    final index = allDocs.indexWhere((d) => d.id == document.id);
    if (index >= 0) {
      allDocs[index] = document;
    } else {
      allDocs.insert(0, document);
    }

    await prefs.setString(
      _keyDocuments,
      jsonEncode(allDocs.map((d) => d.toJson()).toList()),
    );
  }

  Future<void> softDeleteDocument(String id, {required String userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString(_keyDocuments);
    if (rawJson == null) return;

    try {
      final List<dynamic> list = jsonDecode(rawJson) as List<dynamic>;
      final allDocs = list
          .map((item) => DocumentModel.fromJson(item as Map<String, dynamic>))
          .toList();

      final index = allDocs.indexWhere((d) => d.id == id && d.ownerId == userId);
      if (index >= 0) {
        allDocs[index] = allDocs[index].copyWith(deletedAt: DateTime.now());
        await prefs.setString(
          _keyDocuments,
          jsonEncode(allDocs.map((d) => d.toJson()).toList()),
        );
      }
    } catch (_) {}
  }

  Future<void> saveAllDocuments(List<DocumentModel> docs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _keyDocuments,
      jsonEncode(docs.map((d) => d.toJson()).toList()),
    );
  }

  // Preferences persistence
  Future<UserPreferences> getUserPreferences(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_keyPreferencesPrefix$userId');
    if (raw == null || raw.isEmpty) {
      return UserPreferences.defaultPreferences(userId);
    }
    try {
      return UserPreferences.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return UserPreferences.defaultPreferences(userId);
    }
  }

  Future<void> saveUserPreferences(UserPreferences userPreferences) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPreferencesPrefix${userPreferences.ownerId ?? 'guest'}';
    await prefs.setString(key, jsonEncode(userPreferences.toJson()));
  }
}
