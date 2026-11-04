class UserPreferences {
  final String? ownerId;
  final String fontFamily; // 'OpenDyslexic', 'Atkinson Hyperlegible', 'Lexend'
  final int fontSize; // px, 14–32, default 18
  final double letterSpacing; // em, 0–0.12, default 0.04
  final double lineSpacing; // multiplier, 1.5–2.2, default 1.6 (never below 1.5)
  final String? overlayColor; // 'cream', 'blue', 'rose', 'mint', or null
  final double ttsSpeed; // default 1.0 (0.5 to 2.0)
  final DateTime updatedAt;

  const UserPreferences({
    this.ownerId,
    this.fontFamily = 'OpenDyslexic',
    this.fontSize = 18,
    this.letterSpacing = 0.04,
    this.lineSpacing = 1.6,
    this.overlayColor,
    this.ttsSpeed = 1.0,
    required this.updatedAt,
  });

  static UserPreferences defaultPreferences([String? ownerId]) {
    return UserPreferences(
      ownerId: ownerId,
      fontFamily: 'OpenDyslexic',
      fontSize: 18,
      letterSpacing: 0.04,
      lineSpacing: 1.6,
      overlayColor: null,
      ttsSpeed: 1.0,
      updatedAt: DateTime.now(),
    );
  }

  UserPreferences copyWith({
    String? ownerId,
    String? fontFamily,
    int? fontSize,
    double? letterSpacing,
    double? lineSpacing,
    String? overlayColor,
    bool clearOverlay = false,
    double? ttsSpeed,
    DateTime? updatedAt,
  }) {
    // Strict dyslexia rule: lineSpacing must never go below 1.5
    final safeLineSpacing = lineSpacing != null
        ? lineSpacing.clamp(1.5, 2.2)
        : this.lineSpacing.clamp(1.5, 2.2);

    return UserPreferences(
      ownerId: ownerId ?? this.ownerId,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize != null ? fontSize.clamp(14, 32) : this.fontSize,
      letterSpacing: letterSpacing != null ? letterSpacing.clamp(0.0, 0.12) : this.letterSpacing,
      lineSpacing: safeLineSpacing,
      overlayColor: clearOverlay ? null : (overlayColor ?? this.overlayColor),
      ttsSpeed: ttsSpeed != null ? ttsSpeed.clamp(0.5, 2.0) : this.ttsSpeed,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'owner_id': ownerId,
      'font_family': fontFamily,
      'font_size': fontSize,
      'letter_spacing': letterSpacing,
      'line_spacing': lineSpacing,
      'overlay_color': overlayColor,
      'tts_speed': ttsSpeed,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    final rawLineSpacing = (json['line_spacing'] as num?)?.toDouble() ?? 1.6;
    final safeLineSpacing = rawLineSpacing.clamp(1.5, 2.2);

    return UserPreferences(
      ownerId: json['owner_id'] as String?,
      fontFamily: json['font_family'] as String? ?? 'OpenDyslexic',
      fontSize: ((json['font_size'] as num?)?.toInt() ?? 18).clamp(14, 32),
      letterSpacing: ((json['letter_spacing'] as num?)?.toDouble() ?? 0.04).clamp(0.0, 0.12),
      lineSpacing: safeLineSpacing,
      overlayColor: json['overlay_color'] as String?,
      ttsSpeed: ((json['tts_speed'] as num?)?.toDouble() ?? 1.0).clamp(0.5, 2.0),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
