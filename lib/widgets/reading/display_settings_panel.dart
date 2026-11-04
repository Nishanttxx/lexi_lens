import 'package:flutter/material.dart';
import '../../core/models/user_preferences.dart';
import '../../core/theme/app_tokens.dart';
import '../common/app_button.dart';
import 'dyslexia_text_renderer.dart';

class DisplaySettingsPanel extends StatelessWidget {
  final UserPreferences preferences;
  final ValueChanged<UserPreferences> onChanged;
  final VoidCallback? onSaveDefault;
  final VoidCallback? onResetDefaults;
  final bool isLoggedIn;
  final bool showLivePreview;

  const DisplaySettingsPanel({
    super.key,
    required this.preferences,
    required this.onChanged,
    this.onSaveDefault,
    this.onResetDefaults,
    this.isLoggedIn = true,
    this.showLivePreview = true,
  });

  static const String _previewSampleText =
      'The morning sun warmed the pages of the open book, casting clear shadows between each line of text.';

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      decoration: BoxDecoration(
        color: AppTokens.colorBgSurface,
        borderRadius: AppTokens.borderRadiusMd,
        border: Border.all(color: AppTokens.colorBorderDefault, width: 1.5),
        boxShadow: AppTokens.shadow2,
      ),
      padding: const EdgeInsets.all(AppTokens.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTokens.space1),
                decoration: BoxDecoration(
                  color: AppTokens.colorAccentPrimary.withValues(alpha: 0.12),
                  borderRadius: AppTokens.borderRadiusSm,
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: AppTokens.colorAccentPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppTokens.space2),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reading Display Controls',
                      style: TextStyle(
                        color: AppTokens.colorTextPrimary,
                        fontSize: AppTokens.fontSizeLg,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Customize typeface, spacing, and tint to match your eyes',
                      style: TextStyle(
                        color: AppTokens.colorTextSecondary,
                        fontSize: AppTokens.fontSizeXs,
                      ),
                    ),
                  ],
                ),
              ),
              if (onResetDefaults != null)
                TextButton.icon(
                  icon: const Icon(Icons.restart_alt_rounded, size: 16),
                  label: const Text('Reset'),
                  onPressed: onResetDefaults,
                ),
            ],
          ),

          const SizedBox(height: AppTokens.space3),
          const Divider(color: AppTokens.colorBorderDefault, height: 1),
          const SizedBox(height: AppTokens.space3),

          // Live Preview Section
          if (showLivePreview) ...[
            const Row(
              children: [
                Icon(Icons.visibility_outlined, size: 16, color: AppTokens.colorTextSecondary),
                SizedBox(width: AppTokens.space1),
                Text(
                  'Live Preview',
                  style: TextStyle(
                    color: AppTokens.colorTextSecondary,
                    fontSize: AppTokens.fontSizeSm,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTokens.space1),
            DyslexiaTextRenderer(
              text: _previewSampleText,
              preferences: preferences,
              activeWordIndex: 2, // highlight "sun" to demonstrate TTS highlight
            ),
            const SizedBox(height: AppTokens.space4),
          ],

          // 1. Font Family Toggle (Segmented control)
          const Text(
            'Reading Font Family',
            style: TextStyle(
              color: AppTokens.colorTextPrimary,
              fontSize: AppTokens.fontSizeSm,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTokens.space1),
          Wrap(
            spacing: AppTokens.space2,
            runSpacing: AppTokens.space2,
            children: [
              _buildFontSegment('OpenDyslexic', 'OpenDyslexic (Weighted Bottoms)'),
              _buildFontSegment('Atkinson Hyperlegible', 'Atkinson Hyperlegible'),
              _buildFontSegment('Lexend', 'Lexend'),
            ],
          ),

          const SizedBox(height: AppTokens.space4),

          // 2. Sliders Grid
          if (isMobile)
            Column(
              children: [
                _buildFontSizeSlider(),
                const SizedBox(height: AppTokens.space3),
                _buildLineSpacingSlider(),
                const SizedBox(height: AppTokens.space3),
                _buildLetterSpacingSlider(),
                const SizedBox(height: AppTokens.space3),
                _buildTtsSpeedSlider(),
              ],
            )
          else
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildFontSizeSlider()),
                    const SizedBox(width: AppTokens.space4),
                    Expanded(child: _buildLineSpacingSlider()),
                  ],
                ),
                const SizedBox(height: AppTokens.space3),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildLetterSpacingSlider()),
                    const SizedBox(width: AppTokens.space4),
                    Expanded(child: _buildTtsSpeedSlider()),
                  ],
                ),
              ],
            ),

          const SizedBox(height: AppTokens.space4),

          // 3. Color Overlay Tints
          const Text(
            'Background Color Overlay (Visual Stress Reduction)',
            style: TextStyle(
              color: AppTokens.colorTextPrimary,
              fontSize: AppTokens.fontSizeSm,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTokens.space1),
          Wrap(
            spacing: AppTokens.space2,
            runSpacing: AppTokens.space2,
            children: [
              _buildOverlaySwatch(
                key: null,
                label: 'None',
                color: Colors.white,
                semanticName: 'No overlay, warm surface',
              ),
              _buildOverlaySwatch(
                key: 'cream',
                label: 'Warm Cream',
                color: AppTokens.overlayCream,
                semanticName: 'Cream overlay tint',
              ),
              _buildOverlaySwatch(
                key: 'blue',
                label: 'Soft Blue',
                color: AppTokens.overlayBlue,
                semanticName: 'Soft blue overlay tint',
              ),
              _buildOverlaySwatch(
                key: 'rose',
                label: 'Soothing Rose',
                color: AppTokens.overlayRose,
                semanticName: 'Soothing rose overlay tint',
              ),
              _buildOverlaySwatch(
                key: 'mint',
                label: 'Calm Mint',
                color: AppTokens.overlayMint,
                semanticName: 'Calm mint overlay tint',
              ),
            ],
          ),

          if (onSaveDefault != null) ...[
            const SizedBox(height: AppTokens.space4),
            const Divider(color: AppTokens.colorBorderDefault, height: 1),
            const SizedBox(height: AppTokens.space3),
            Align(
              alignment: Alignment.centerRight,
              child: AppButton(
                text: isLoggedIn ? 'Save as my default settings' : 'Sign in to save defaults',
                icon: isLoggedIn ? Icons.bookmark_added_outlined : Icons.lock_outline_rounded,
                variant: AppButtonVariant.primary,
                onPressed: onSaveDefault,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFontSegment(String key, String label) {
    final isSelected = preferences.fontFamily == key;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        onChanged(preferences.copyWith(fontFamily: key));
      },
      selectedColor: AppTokens.colorAccentPrimary.withValues(alpha: 0.15),
      backgroundColor: AppTokens.colorBgSurfaceMuted,
      labelStyle: TextStyle(
        color: isSelected ? AppTokens.colorAccentPrimary : AppTokens.colorTextPrimary,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        fontSize: AppTokens.fontSizeSm,
      ),
      side: BorderSide(
        color: isSelected ? AppTokens.colorAccentPrimary : AppTokens.colorBorderDefault,
        width: isSelected ? 2.0 : 1.0,
      ),
    );
  }

  Widget _buildOverlaySwatch({
    required String? key,
    required String label,
    required Color color,
    required String semanticName,
  }) {
    final isSelected = preferences.overlayColor == key;
    return Semantics(
      button: true,
      label: '$semanticName. ${isSelected ? "Currently selected." : ""}',
      child: InkWell(
        onTap: () {
          onChanged(preferences.copyWith(
            overlayColor: key,
            clearOverlay: key == null,
          ));
        },
        borderRadius: AppTokens.borderRadiusSm,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.space3,
            vertical: AppTokens.space2,
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppTokens.borderRadiusSm,
            border: Border.all(
              color: isSelected ? AppTokens.colorStateFocus : AppTokens.colorBorderDefault,
              width: isSelected ? 2.5 : 1.0,
            ),
            boxShadow: isSelected ? AppTokens.shadow2 : AppTokens.shadow1,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: AppTokens.colorAccentPrimary,
                )
              else
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTokens.colorBorderStrong),
                  ),
                ),
              const SizedBox(width: AppTokens.space1),
              Text(
                label,
                style: TextStyle(
                  color: AppTokens.colorTextPrimary,
                  fontSize: AppTokens.fontSizeXs,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFontSizeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Font Size (14–32px)',
              style: TextStyle(
                color: AppTokens.colorTextSecondary,
                fontSize: AppTokens.fontSizeXs,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${preferences.fontSize} px',
              style: const TextStyle(
                color: AppTokens.colorTextPrimary,
                fontSize: AppTokens.fontSizeSm,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Slider(
          value: preferences.fontSize.toDouble().clamp(14.0, 32.0),
          min: 14.0,
          max: 32.0,
          divisions: 18,
          semanticFormatterCallback: (val) => '${val.round()} pixels',
          onChanged: (val) {
            onChanged(preferences.copyWith(fontSize: val.round()));
          },
        ),
      ],
    );
  }

  Widget _buildLineSpacingSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Line Spacing (Min 1.5x–2.2x)',
              style: TextStyle(
                color: AppTokens.colorTextSecondary,
                fontSize: AppTokens.fontSizeXs,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${preferences.lineSpacing.toStringAsFixed(1)}x',
              style: const TextStyle(
                color: AppTokens.colorTextPrimary,
                fontSize: AppTokens.fontSizeSm,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Slider(
          value: preferences.lineSpacing.clamp(1.5, 2.2),
          min: 1.5, // Strict non-negotiable rule: never below 1.5!
          max: 2.2,
          divisions: 7,
          semanticFormatterCallback: (val) => '${val.toStringAsFixed(1)} line spacing multiplier',
          onChanged: (val) {
            onChanged(preferences.copyWith(
              lineSpacing: double.parse(val.toStringAsFixed(1)),
            ));
          },
        ),
      ],
    );
  }

  Widget _buildLetterSpacingSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Letter Spacing (0–0.12em)',
              style: TextStyle(
                color: AppTokens.colorTextSecondary,
                fontSize: AppTokens.fontSizeXs,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${(preferences.letterSpacing * 100).round()}%',
              style: const TextStyle(
                color: AppTokens.colorTextPrimary,
                fontSize: AppTokens.fontSizeSm,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Slider(
          value: preferences.letterSpacing.clamp(0.0, 0.12),
          min: 0.0,
          max: 0.12,
          divisions: 12,
          semanticFormatterCallback: (val) => '${(val * 100).round()} percent extra letter spacing',
          onChanged: (val) {
            onChanged(preferences.copyWith(
              letterSpacing: double.parse(val.toStringAsFixed(3)),
            ));
          },
        ),
      ],
    );
  }

  Widget _buildTtsSpeedSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Audio Speech Speed (0.5x–2.0x)',
              style: TextStyle(
                color: AppTokens.colorTextSecondary,
                fontSize: AppTokens.fontSizeXs,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${preferences.ttsSpeed.toStringAsFixed(2)}x',
              style: const TextStyle(
                color: AppTokens.colorTextPrimary,
                fontSize: AppTokens.fontSizeSm,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Slider(
          value: preferences.ttsSpeed.clamp(0.5, 2.0),
          min: 0.5,
          max: 2.0,
          divisions: 6,
          semanticFormatterCallback: (val) => '${val.toStringAsFixed(2)} speed multiplier',
          onChanged: (val) {
            onChanged(preferences.copyWith(
              ttsSpeed: double.parse(val.toStringAsFixed(2)),
            ));
          },
        ),
      ],
    );
  }
}
