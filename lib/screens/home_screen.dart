import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/auth_service.dart';
import '../core/theme/app_tokens.dart';
import '../widgets/capture/camera_capture.dart';
import '../widgets/capture/sample_picker.dart';
import '../widgets/capture/upload_picker.dart';
import '../widgets/common/app_card.dart';
import '../widgets/common/error_banner.dart';
import '../widgets/navigation/guest_banner.dart';

class HomeScreen extends StatefulWidget {
  final Function(String route, {Map<String, dynamic>? arguments}) onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCaptureTab = 0; // 0 = Camera, 1 = Upload
  String? _errorMessage;

  void _processImage({
    Uint8List? bytes,
    String? fileName,
    String? sampleKey,
    String? sampleTitle,
    required String source,
  }) {
    setState(() => _errorMessage = null);

    widget.onNavigate('/scan/processing', arguments: {
      'imageBytes': bytes,
      'fileName': fileName,
      'sampleKey': sampleKey,
      'title': sampleTitle ?? (fileName != null ? 'Scan: $fileName' : 'Camera snapshot'),
      'source': source,
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final isGuest = authService.isGuest;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Guest notice banner
          if (isGuest && !authService.isLoggedIn)
            GuestBanner(
              onLogin: () => widget.onNavigate('/login'),
            ),

          // Main Container
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? AppTokens.space3 : AppTokens.space6,
              vertical: AppTokens.space4,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1040),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Section
                  _buildHeroSection(isMobile),

                  const SizedBox(height: AppTokens.space5),

                  if (_errorMessage != null) ...[
                    ErrorBanner(
                      message: _errorMessage!,
                      onDismiss: () => setState(() => _errorMessage = null),
                    ),
                    const SizedBox(height: AppTokens.space3),
                  ],

                  // Capture Workspace Card
                  _buildCaptureWorkspace(isMobile),

                  const SizedBox(height: AppTokens.space6),

                  // Value Pillars / Mission Info
                  _buildFeaturePillars(isMobile),

                  const SizedBox(height: AppTokens.space6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTokens.space3,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppTokens.colorAccentPrimary.withValues(alpha: 0.12),
                borderRadius: AppTokens.borderRadiusPill,
                border: Border.all(
                  color: AppTokens.colorAccentPrimary.withValues(alpha: 0.4),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: 14,
                    color: AppTokens.colorAccentPrimary,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'ACCESSIBLE READING TOOLKIT',
                    style: TextStyle(
                      color: AppTokens.colorAccentPrimary,
                      fontSize: AppTokens.fontSizeXs,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTokens.space3),
        Text(
          'Point a camera at printed text, get back something you can actually read and hear.',
          style: TextStyle(
            color: AppTokens.colorTextPrimary,
            fontSize: isMobile ? AppTokens.fontSize2xl : AppTokens.fontSize4xl,
            fontWeight: FontWeight.w700,
            height: 1.25,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: AppTokens.space2),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: const Text(
            'Lexi Lens transforms printed pages, worksheets, and documents into high-legibility typography with weighted letterforms, customizable line and letter spacing, glare-reducing color tints, and synchronized read-aloud audio.',
            style: TextStyle(
              color: AppTokens.colorTextSecondary,
              fontSize: AppTokens.fontSizeMd,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCaptureWorkspace(bool isMobile) {
    return AppCard(
      padding: const EdgeInsets.all(AppTokens.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mode Toggle (Camera vs Upload)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTokens.colorBgSurfaceMuted,
              borderRadius: AppTokens.borderRadiusSm,
              border: Border.all(color: AppTokens.colorBorderDefault),
            ),
            child: Wrap(
              spacing: AppTokens.space1,
              runSpacing: AppTokens.space1,
              children: [
                _buildTabButton(
                  index: 0,
                  label: 'Snap with camera',
                  icon: Icons.camera_alt_outlined,
                ),
                _buildTabButton(
                  index: 1,
                  label: 'Upload image or PDF',
                  icon: Icons.upload_file_outlined,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTokens.space4),

          // Capture Widget Body
          if (_selectedCaptureTab == 0)
            CameraCapture(
              onCapture: (bytes, label) {
                _processImage(
                  bytes: bytes,
                  source: 'camera',
                  sampleTitle: 'Camera snapshot',
                );
              },
              onSwitchToUpload: () {
                setState(() => _selectedCaptureTab = 1);
              },
            )
          else
            UploadPicker(
              onFileSelected: (bytes, fileName) {
                _processImage(
                  bytes: bytes,
                  fileName: fileName,
                  source: 'upload',
                  sampleTitle: fileName,
                );
              },
              onError: (err) {
                setState(() => _errorMessage = err);
              },
            ),

          const SizedBox(height: AppTokens.space4),
          const Divider(color: AppTokens.colorBorderDefault, height: 1),
          const SizedBox(height: AppTokens.space4),

          // Instant demo samples for effortless evaluation
          SamplePicker(
            onSelectSample: (key, title) {
              _processImage(
                sampleKey: key,
                sampleTitle: title,
                source: 'sample',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required int index,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _selectedCaptureTab == index;
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: InkWell(
        onTap: () => setState(() => _selectedCaptureTab = index),
        borderRadius: AppTokens.borderRadiusSm,
        child: AnimatedContainer(
          duration: AppTokens.durationFast,
          constraints: const BoxConstraints(minHeight: AppTokens.minTouchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.space4,
            vertical: AppTokens.space2,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppTokens.colorBgSurface : Colors.transparent,
            borderRadius: AppTokens.borderRadiusSm,
            boxShadow: isSelected ? AppTokens.shadow1 : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? AppTokens.colorAccentPrimary
                    : AppTokens.colorTextSecondary,
              ),
              const SizedBox(width: AppTokens.space2),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? AppTokens.colorAccentPrimary
                      : AppTokens.colorTextSecondary,
                  fontSize: AppTokens.fontSizeSm,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturePillars(bool isMobile) {
    final pillars = [
      {
        'title': 'Dyslexia-Optimized Fonts',
        'desc': 'OpenDyslexic and Atkinson Hyperlegible feature distinct letter shapes and weighted bottoms to prevent visual crowding.',
        'icon': Icons.font_download_outlined,
      },
      {
        'title': 'Low-Glare Color Overlays',
        'desc': 'Warm cream, soft blue, soothing rose, and calm mint tints eliminate stark white contrast and visual buzzing.',
        'icon': Icons.palette_outlined,
      },
      {
        'title': 'Synchronized Read-Aloud',
        'desc': 'Listen to text spoken clearly with gentle amber highlighting that tracks each word in sync with speech.',
        'icon': Icons.record_voice_over_outlined,
      },
    ];

    if (isMobile) {
      return Column(
        children: pillars.map((p) => _buildPillarCard(p)).toList(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: pillars.map((p) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTokens.space2),
          child: _buildPillarCard(p),
        ),
      )).toList(),
    );
  }

  Widget _buildPillarCard(Map<String, dynamic> pillar) {
    return Container(
      padding: const EdgeInsets.all(AppTokens.space4),
      margin: const EdgeInsets.only(bottom: AppTokens.space2),
      decoration: BoxDecoration(
        color: AppTokens.colorBgSurface,
        borderRadius: AppTokens.borderRadiusMd,
        border: Border.all(color: AppTokens.colorBorderDefault, width: 1.0),
        boxShadow: AppTokens.shadow1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTokens.space2),
            decoration: BoxDecoration(
              color: AppTokens.colorAccentPrimary.withValues(alpha: 0.12),
              borderRadius: AppTokens.borderRadiusSm,
            ),
            child: Icon(
              pillar['icon'] as IconData,
              size: 24,
              color: AppTokens.colorAccentPrimary,
            ),
          ),
          const SizedBox(height: AppTokens.space3),
          Text(
            pillar['title'] as String,
            style: const TextStyle(
              color: AppTokens.colorTextPrimary,
              fontSize: AppTokens.fontSizeMd,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppTokens.space1),
          Text(
            pillar['desc'] as String,
            style: const TextStyle(
              color: AppTokens.colorTextSecondary,
              fontSize: AppTokens.fontSizeSm,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
