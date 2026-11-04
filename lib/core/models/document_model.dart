class DocumentModel {
  final String id;
  final String? ownerId;
  final String title;
  final String rawText;
  final String? imageStoragePath;
  final String source; // 'camera' or 'upload'
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final double confidence;

  DocumentModel({
    required this.id,
    this.ownerId,
    required this.title,
    required this.rawText,
    this.imageStoragePath,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.confidence = 0.95,
  });

  DocumentModel copyWith({
    String? id,
    String? ownerId,
    String? title,
    String? rawText,
    String? imageStoragePath,
    String? source,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    double? confidence,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      rawText: rawText ?? this.rawText,
      imageStoragePath: imageStoragePath ?? this.imageStoragePath,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      confidence: confidence ?? this.confidence,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'title': title,
      'raw_text': rawText,
      'image_storage_path': imageStoragePath,
      'source': source,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'confidence': confidence,
    };
  }

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String?,
      title: json['title'] as String? ?? 'Untitled Scan',
      rawText: json['raw_text'] as String? ?? '',
      imageStoragePath: json['image_storage_path'] as String?,
      source: json['source'] as String? ?? 'upload',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'] as String)
          : null,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.95,
    );
  }
}
