import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_tokens.dart';
import '../common/app_button.dart';

class UploadPicker extends StatefulWidget {
  final Function(Uint8List bytes, String fileName) onFileSelected;
  final Function(String error) onError;

  const UploadPicker({
    super.key,
    required this.onFileSelected,
    required this.onError,
  });

  @override
  State<UploadPicker> createState() => _UploadPickerState();
}

class _UploadPickerState extends State<UploadPicker> {
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isLoading = false;

  Future<void> _pickFile() async {
    setState(() => _isLoading = true);
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (files.isNotEmpty) {
        final file = files.first;
        final bytes = await file.xFile.readAsBytes();
        // Check 10MB limit per PRD
        if (bytes.lengthInBytes > 10 * 1024 * 1024) {
          widget.onError('File exceeds maximum size of 10MB. Please select a smaller image or document.');
          return;
        }
        widget.onFileSelected(bytes, file.name);
      }
    } catch (e) {
      widget.onError('Could not open file: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Upload image or document. Select a PNG, JPG, or PDF file up to 10MB.',
      child: FocusableActionDetector(
        onShowFocusHighlight: (v) => setState(() => _isFocused = v),
        onShowHoverHighlight: (v) => setState(() => _isHovered = v),
        mouseCursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _isLoading ? null : _pickFile,
          child: AnimatedContainer(
            duration: AppTokens.durationFast,
            padding: const EdgeInsets.symmetric(
              horizontal: AppTokens.space4,
              vertical: AppTokens.space6,
            ),
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppTokens.colorBgSurfaceMuted
                  : AppTokens.colorBgSurface,
              borderRadius: AppTokens.borderRadiusMd,
              border: Border.all(
                color: _isFocused
                    ? AppTokens.colorStateFocus
                    : (_isHovered ? AppTokens.colorAccentPrimary : AppTokens.colorBorderDefault),
                width: _isFocused ? 2.0 : 1.5,
              ),
              boxShadow: _isHovered ? AppTokens.shadow2 : AppTokens.shadow1,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppTokens.colorAccentPrimary.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.upload_file_rounded,
                    color: AppTokens.colorAccentPrimary,
                    size: 32,
                  ),
                ),
                const SizedBox(height: AppTokens.space3),
                const Text(
                  'Upload a photo or document',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTokens.colorTextPrimary,
                    fontSize: AppTokens.fontSizeLg,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppTokens.space1),
                const Text(
                  'Supports PNG, JPG, or PDF (up to 10MB)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTokens.colorTextSecondary,
                    fontSize: AppTokens.fontSizeSm,
                  ),
                ),
                const SizedBox(height: AppTokens.space4),
                AppButton(
                  text: _isLoading ? 'Selecting…' : 'Browse files',
                  icon: Icons.folder_open_rounded,
                  variant: AppButtonVariant.primary,
                  isLoading: _isLoading,
                  onPressed: _pickFile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
