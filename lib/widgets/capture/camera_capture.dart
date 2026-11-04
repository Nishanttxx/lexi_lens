import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../core/theme/app_tokens.dart';
import '../common/app_button.dart';

class CameraCapture extends StatefulWidget {
  final Function(Uint8List? bytes, String label) onCapture;
  final VoidCallback? onSwitchToUpload;

  const CameraCapture({
    super.key,
    required this.onCapture,
    this.onSwitchToUpload,
  });

  @override
  State<CameraCapture> createState() => _CameraCaptureState();
}

class _CameraCaptureState extends State<CameraCapture> {
  bool _isCapturing = false;
  bool _showFlash = false;
  bool _permissionDenied = false;

  void _triggerCapture() async {
    setState(() {
      _isCapturing = true;
      _showFlash = true;
    });

    await Future.delayed(const Duration(milliseconds: 140));
    if (mounted) setState(() => _showFlash = false);

    await Future.delayed(const Duration(milliseconds: 260));
    if (mounted) {
      setState(() => _isCapturing = false);
      widget.onCapture(null, 'Camera Snapshot');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionDenied) {
      return Container(
        decoration: BoxDecoration(
          color: AppTokens.colorBgSurfaceMuted,
          borderRadius: AppTokens.borderRadiusMd,
          border: Border.all(color: AppTokens.colorBorderDefault, width: 1.5),
        ),
        padding: const EdgeInsets.all(AppTokens.space5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTokens.space3),
              decoration: BoxDecoration(
                color: const Color(0xFFFBECE9),
                shape: BoxShape.circle,
                border: Border.all(color: AppTokens.colorStateError, width: 1.5),
              ),
              child: const Icon(
                Icons.no_photography_outlined,
                size: 32,
                color: AppTokens.colorStateError,
              ),
            ),
            const SizedBox(height: AppTokens.space3),
            const Text(
              'Camera Access Needed',
              style: TextStyle(
                color: AppTokens.colorTextPrimary,
                fontSize: AppTokens.fontSizeLg,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppTokens.space2),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: const Text(
                'Enable camera access in your browser or device settings, or upload a photo instead.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTokens.colorTextSecondary,
                  fontSize: AppTokens.fontSizeSm,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: AppTokens.space4),
            Wrap(
              spacing: AppTokens.space3,
              runSpacing: AppTokens.space2,
              alignment: WrapAlignment.center,
              children: [
                if (widget.onSwitchToUpload != null)
                  AppButton(
                    text: 'Upload instead',
                    icon: Icons.upload_file_rounded,
                    variant: AppButtonVariant.primary,
                    onPressed: widget.onSwitchToUpload,
                  ),
                AppButton(
                  text: 'Try camera again',
                  icon: Icons.refresh_rounded,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => setState(() => _permissionDenied = false),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTokens.colorBgSurface,
        borderRadius: AppTokens.borderRadiusMd,
        border: Border.all(color: AppTokens.colorBorderDefault, width: 1.5),
        boxShadow: AppTokens.shadow1,
      ),
      padding: const EdgeInsets.all(AppTokens.space4),
      child: Column(
        children: [
          // Viewfinder simulation
          Semantics(
            label: 'Camera viewfinder. Hold printed text inside the frame and tap Take photo.',
            child: ClipRRect(
              borderRadius: AppTokens.borderRadiusSm,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 220,
                    width: double.infinity,
                    color: const Color(0xFF2B2521),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppTokens.space3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTokens.colorAccentPrimary.withValues(alpha: 0.6),
                                width: 2.0,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              size: 32,
                              color: AppTokens.colorTextInverse,
                            ),
                          ),
                          const SizedBox(height: AppTokens.space2),
                          const Text(
                            'Hold camera steady over printed text',
                            style: TextStyle(
                              color: AppTokens.colorTextInverse,
                              fontSize: AppTokens.fontSizeSm,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Works best with books, worksheets, and clear lighting',
                            style: TextStyle(
                              color: AppTokens.colorTextInverse.withValues(alpha: 0.8),
                              fontSize: AppTokens.fontSizeXs,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Viewfinder alignment guides
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTokens.space4),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTokens.colorAccentWarm.withValues(alpha: 0.7),
                            width: 1.5,
                          ),
                          borderRadius: AppTokens.borderRadiusSm,
                        ),
                      ),
                    ),
                  ),

                  // Shutter flash effect
                  if (_showFlash)
                    Positioned.fill(
                      child: Container(color: Colors.white.withValues(alpha: 0.9)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppTokens.space4),
          Wrap(
            spacing: AppTokens.space3,
            runSpacing: AppTokens.space2,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppButton(
                text: _isCapturing ? 'Taking photo…' : 'Take photo',
                icon: Icons.camera_rounded,
                variant: AppButtonVariant.primary,
                isLoading: _isCapturing,
                onPressed: _triggerCapture,
                semanticLabel: 'Take photo of printed text',
              ),
              if (widget.onSwitchToUpload != null)
                AppButton(
                  text: 'Upload file instead',
                  icon: Icons.upload_file_outlined,
                  variant: AppButtonVariant.secondary,
                  onPressed: widget.onSwitchToUpload,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
