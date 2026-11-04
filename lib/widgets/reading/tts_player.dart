import 'package:flutter/material.dart';
import '../../core/services/tts_service.dart';
import '../../core/theme/app_tokens.dart';
import '../common/app_button.dart';

class TTSPlayer extends StatelessWidget {
  final TtsService ttsService;
  final String textToSpeak;

  const TTSPlayer({
    super.key,
    required this.ttsService,
    required this.textToSpeak,
  });

  @override
  Widget build(BuildContext context) {
    final isPlaying = ttsService.isPlaying;
    final isPaused = ttsService.isPaused;
    final state = ttsService.state;
    final progress = ttsService.progress;
    final speed = ttsService.speed;
    final wordCount = ttsService.words.length;
    final currentWordIndex = ttsService.currentWordIndex;

    final stateAnnouncement = isPlaying
        ? 'Audio playing, word ${currentWordIndex + 1} of $wordCount'
        : (isPaused ? 'Audio paused' : 'Audio idle');

    return Semantics(
      liveRegion: true,
      label: 'Text to speech player. $stateAnnouncement',
      child: Container(
        padding: const EdgeInsets.all(AppTokens.space3),
        decoration: BoxDecoration(
          color: AppTokens.colorBgSurface,
          borderRadius: AppTokens.borderRadiusMd,
          border: Border.all(color: AppTokens.colorBorderDefault, width: 1.5),
          boxShadow: AppTokens.shadow2,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scrub / Progress Bar
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTokens.colorAccentWarm.withValues(alpha: 0.2),
                    borderRadius: AppTokens.borderRadiusSm,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.record_voice_over_rounded,
                        size: 14,
                        color: AppTokens.colorAccentWarm,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${(progress * 100).round()}%',
                        style: const TextStyle(
                          color: AppTokens.colorTextPrimary,
                          fontSize: AppTokens.fontSizeXs,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppTokens.space2),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: AppTokens.colorAccentWarm,
                      inactiveTrackColor: AppTokens.colorBorderDefault,
                      thumbColor: AppTokens.colorAccentWarm,
                      overlayColor: AppTokens.colorAccentWarm.withValues(alpha: 0.15),
                      trackHeight: 5.0,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7.0),
                    ),
                    child: Slider(
                      value: progress.clamp(0.0, 1.0),
                      semanticFormatterCallback: (val) => '${(val * 100).round()} percent audio progress',
                      onChanged: (val) {
                        if (wordCount > 0) {
                          final targetWord = (val * (wordCount - 1)).round();
                          ttsService.seekToWord(targetWord);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: AppTokens.space2),
                Text(
                  currentWordIndex >= 0 ? '${currentWordIndex + 1} / $wordCount words' : '$wordCount words',
                  style: const TextStyle(
                    color: AppTokens.colorTextSecondary,
                    fontSize: AppTokens.fontSizeXs,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTokens.space2),

            // Controls Row
            Row(
              children: [
                // Primary Play / Pause / Speak button
                if (isPlaying)
                  AppButton(
                    text: 'Pause audio',
                    icon: Icons.pause_rounded,
                    variant: AppButtonVariant.primary,
                    onPressed: () => ttsService.pause(),
                    semanticLabel: 'Pause read aloud audio',
                  )
                else if (isPaused)
                  AppButton(
                    text: 'Resume reading',
                    icon: Icons.play_arrow_rounded,
                    variant: AppButtonVariant.primary,
                    onPressed: () => ttsService.resume(),
                    semanticLabel: 'Resume read aloud audio',
                  )
                else
                  AppButton(
                    text: state == TtsPlaybackState.loading ? 'Preparing audio…' : 'Read aloud',
                    icon: Icons.volume_up_rounded,
                    variant: AppButtonVariant.primary,
                    isLoading: state == TtsPlaybackState.loading,
                    onPressed: () => ttsService.speak(textToSpeak),
                    semanticLabel: 'Start reading document aloud with word highlighting',
                  ),

                const SizedBox(width: AppTokens.space2),

                // Stop button
                if (isPlaying || isPaused)
                  IconButton(
                    icon: const Icon(Icons.stop_rounded, color: AppTokens.colorTextSecondary),
                    onPressed: () => ttsService.stop(),
                    tooltip: 'Stop reading audio',
                    constraints: const BoxConstraints(
                      minWidth: AppTokens.minTouchTarget,
                      minHeight: AppTokens.minTouchTarget,
                    ),
                  ),

                const Spacer(),

                // Speed readout / adjustment
                const Text(
                  'Speed: ',
                  style: TextStyle(
                    color: AppTokens.colorTextSecondary,
                    fontSize: AppTokens.fontSizeSm,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppTokens.space2, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTokens.colorBgSurfaceMuted,
                    borderRadius: AppTokens.borderRadiusSm,
                    border: Border.all(color: AppTokens.colorBorderDefault),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<double>(
                      value: speed,
                      dropdownColor: AppTokens.colorBgSurface,
                      style: const TextStyle(
                        color: AppTokens.colorTextPrimary,
                        fontSize: AppTokens.fontSizeSm,
                        fontWeight: FontWeight.w600,
                      ),
                      items: const [
                        DropdownMenuItem(value: 0.75, child: Text('0.75x (Slow)')),
                        DropdownMenuItem(value: 1.0, child: Text('1.00x (Normal)')),
                        DropdownMenuItem(value: 1.25, child: Text('1.25x (Gentle)')),
                        DropdownMenuItem(value: 1.5, child: Text('1.50x (Brisk)')),
                        DropdownMenuItem(value: 2.0, child: Text('2.00x (Fast)')),
                      ],
                      onChanged: (newSpeed) {
                        if (newSpeed != null) ttsService.setSpeed(newSpeed);
                      },
                    ),
                  ),
                ),
              ],
            ),

            if (ttsService.errorMessage != null) ...[
              const SizedBox(height: AppTokens.space2),
              Row(
                children: [
                  const Icon(Icons.error_outline_rounded, size: 16, color: AppTokens.colorStateError),
                  const SizedBox(width: AppTokens.space1),
                  Expanded(
                    child: Text(
                      ttsService.errorMessage!,
                      style: const TextStyle(
                        color: AppTokens.colorStateError,
                        fontSize: AppTokens.fontSizeXs,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
