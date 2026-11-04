import 'package:flutter/material.dart';
import '../../core/theme/app_tokens.dart';

class SamplePicker extends StatelessWidget {
  final Function(String presetKey, String title) onSelectSample;

  const SamplePicker({super.key, required this.onSelectSample});

  @override
  Widget build(BuildContext context) {
    final samples = [
      {
        'key': 'science',
        'title': 'Science Article',
        'desc': 'Photosynthesis and plant energy',
        'icon': Icons.science_outlined,
      },
      {
        'key': 'history',
        'title': 'History Textbook',
        'desc': 'The Ancient Library of Alexandria',
        'icon': Icons.menu_book_outlined,
      },
      {
        'key': 'worksheet',
        'title': 'School Worksheet',
        'desc': 'Deep sea ocean trenches',
        'icon': Icons.assignment_outlined,
      },
      {
        'key': 'book',
        'title': 'Fiction Storybook',
        'desc': 'The quiet forest trail',
        'icon': Icons.auto_stories_outlined,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Or try a quick reading sample:',
          style: TextStyle(
            color: AppTokens.colorTextPrimary,
            fontSize: AppTokens.fontSizeSm,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTokens.space2),
        Wrap(
          spacing: AppTokens.space2,
          runSpacing: AppTokens.space2,
          children: samples.map((sample) {
            return _SampleChip(
              title: sample['title'] as String,
              desc: sample['desc'] as String,
              icon: sample['icon'] as IconData,
              onTap: () => onSelectSample(
                sample['key'] as String,
                sample['title'] as String,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SampleChip extends StatefulWidget {
  final String title;
  final String desc;
  final IconData icon;
  final VoidCallback onTap;

  const _SampleChip({
    required this.title,
    required this.desc,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_SampleChip> createState() => _SampleChipState();
}

class _SampleChipState extends State<_SampleChip> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Sample: ${widget.title}, ${widget.desc}. Tap to read immediately.',
      child: FocusableActionDetector(
        onShowFocusHighlight: (v) => setState(() => _isFocused = v),
        onShowHoverHighlight: (v) => setState(() => _isHovered = v),
        mouseCursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: AppTokens.durationFast,
            constraints: const BoxConstraints(minHeight: AppTokens.minTouchTarget),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTokens.space3,
              vertical: AppTokens.space2,
            ),
            decoration: BoxDecoration(
              color: _isHovered ? AppTokens.colorBgSurfaceMuted : AppTokens.colorBgSurface,
              borderRadius: AppTokens.borderRadiusSm,
              border: Border.all(
                color: _isFocused
                    ? AppTokens.colorStateFocus
                    : (_isHovered ? AppTokens.colorAccentPrimary : AppTokens.colorBorderDefault),
                width: _isFocused ? 2.0 : 1.0,
              ),
              boxShadow: _isHovered ? AppTokens.shadow2 : AppTokens.shadow1,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  size: 20,
                  color: AppTokens.colorAccentPrimary,
                ),
                const SizedBox(width: AppTokens.space2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: AppTokens.colorTextPrimary,
                        fontSize: AppTokens.fontSizeSm,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.desc,
                      style: const TextStyle(
                        color: AppTokens.colorTextSecondary,
                        fontSize: AppTokens.fontSizeXs,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
