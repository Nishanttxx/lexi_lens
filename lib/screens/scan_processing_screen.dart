import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/models/document_model.dart';
import '../core/services/auth_service.dart';
import '../core/services/ocr_service.dart';
import '../core/services/storage_service.dart';
import '../core/theme/app_tokens.dart';
import '../widgets/common/error_banner.dart';
import '../widgets/common/loading_indicator.dart';

class ScanProcessingScreen extends StatefulWidget {
  final Map<String, dynamic> arguments;
  final Function(String route, {Map<String, dynamic>? arguments}) onNavigate;

  const ScanProcessingScreen({
    super.key,
    required this.arguments,
    required this.onNavigate,
  });

  @override
  State<ScanProcessingScreen> createState() => _ScanProcessingScreenState();
}

class _ScanProcessingScreenState extends State<ScanProcessingScreen> {
  final OcrService _ocrService = OcrService();
  final StorageService _storageService = StorageService();

  String _statusText = 'Reading your image…';
  String _stepDetail = 'Detecting printed lines and letter boundaries';
  double _progress = 0.25;
  String? _errorMessage;
  bool _isCancelled = false;

  @override
  void initState() {
    super.initState();
    _startOcr();
  }

  Future<void> _startOcr() async {
    setState(() {
      _errorMessage = null;
      _statusText = 'Reading your image…';
      _stepDetail = 'Detecting printed lines and letter boundaries';
      _progress = 0.25;
    });

    final imageBytes = widget.arguments['imageBytes'] as Uint8List?;
    final fileName = widget.arguments['fileName'] as String?;
    final sampleKey = widget.arguments['sampleKey'] as String?;
    final title = widget.arguments['title'] as String? ?? 'Scanned Document';
    final source = widget.arguments['source'] as String? ?? 'upload';

    await Future.delayed(const Duration(milliseconds: 400));
    if (_isCancelled || !mounted) return;
    setState(() {
      _statusText = 'Extracting text…';
      _stepDetail = 'Analyzing letterforms and words';
      _progress = 0.65;
    });

    final result = await _ocrService.extractText(
      imageBytes: imageBytes,
      fileName: fileName,
      sampleType: sampleKey,
    );

    if (_isCancelled || !mounted) return;

    if (!result.isSuccess) {
      setState(() {
        _errorMessage = result.errorMessage ??
            "We couldn't find readable text in that image. Try better lighting or hold the camera steady.";
      });
      return;
    }

    setState(() {
      _statusText = 'Formatting layout…';
      _stepDetail = 'Applying dyslexia typography and spacing';
      _progress = 0.95;
    });

    await Future.delayed(const Duration(milliseconds: 300));
    if (_isCancelled || !mounted) return;

    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.currentUser?.id;

    // Create the document
    final docId = 'doc_${DateTime.now().millisecondsSinceEpoch}';
    final document = DocumentModel(
      id: docId,
      ownerId: userId,
      title: title,
      rawText: result.text,
      source: source,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      confidence: result.confidence,
    );

    // If logged in, automatically persist document
    if (authService.isLoggedIn && userId != null) {
      await _storageService.saveDocument(document);
    }

    widget.onNavigate('/read', arguments: {
      'document': document,
      'isNewScan': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.space4),
          child: _errorMessage != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ErrorBanner(
                      title: 'Could not read text',
                      message: _errorMessage!,
                      retryText: 'Try scanning again',
                      onRetry: _startOcr,
                    ),
                    const SizedBox(height: AppTokens.space3),
                    TextButton.icon(
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Return to scan'),
                      onPressed: () => widget.onNavigate('/app'),
                    ),
                  ],
                )
              : LoadingIndicator(
                  status: _statusText,
                  subtitle: _stepDetail,
                  progress: _progress,
                  onCancel: () {
                    _isCancelled = true;
                    widget.onNavigate('/app');
                  },
                ),
        ),
      ),
    );
  }
}
