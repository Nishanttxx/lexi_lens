import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/models/document_model.dart';
import '../core/models/user_preferences.dart';
import '../core/services/auth_service.dart';
import '../core/services/storage_service.dart';
import '../core/services/tts_service.dart';
import '../core/theme/app_tokens.dart';
import '../widgets/common/app_badge.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/toast.dart';
import '../widgets/reading/display_settings_panel.dart';
import '../widgets/reading/dyslexia_text_renderer.dart';
import '../widgets/reading/tts_player.dart';

class ReadingScreen extends StatefulWidget {
  final Map<String, dynamic> arguments;
  final Function(String route, {Map<String, dynamic>? arguments}) onNavigate;

  const ReadingScreen({
    super.key,
    required this.arguments,
    required this.onNavigate,
  });

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  final StorageService _storageService = StorageService();
  late TtsService _ttsService;

  late DocumentModel _document;
  late UserPreferences _preferences;
  bool _isLoadingPreferences = true;
  bool _showSettingsPanel = false;
  bool _isEditing = false;
  late TextEditingController _textEditingController;
  late TextEditingController _titleEditingController;

  @override
  void initState() {
    super.initState();
    _ttsService = TtsService();

    final docArg = widget.arguments['document'] as DocumentModel?;
    if (docArg != null) {
      _document = docArg;
    } else {
      _document = DocumentModel(
        id: 'sample-doc',
        title: 'Dyslexia Reading Experience',
        rawText:
            'Welcome to Lexi Lens. Readers with dyslexia often find that standard publishing fonts cause visual fatigue, crowding, and skipping lines. '
            'With open letter shapes, heavier bottoms that anchor the baseline, and soothing colored overlays, your brain can decode '
            'and comprehend words with clarity and confidence.',
        source: 'sample',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    _textEditingController = TextEditingController(text: _document.rawText);
    _titleEditingController = TextEditingController(text: _document.title);
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.currentUser?.id ?? 'guest';
    final savedPrefs = await _storageService.getUserPreferences(userId);

    if (mounted) {
      setState(() {
        _preferences = savedPrefs;
        _isLoadingPreferences = false;
      });
    }
  }

  void _saveCurrentText() {
    setState(() {
      _document = _document.copyWith(
        rawText: _textEditingController.text,
        title: _titleEditingController.text,
        updatedAt: DateTime.now(),
      );
      _isEditing = false;
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    if (authService.isLoggedIn) {
      _storageService.saveDocument(_document);
      AppToast.show(context, 'Document updated in your library.');
    } else {
      AppToast.show(context, 'Text updated.');
    }
  }

  Future<void> _saveDocumentToLibrary() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    if (!authService.isLoggedIn) {
      _promptLoginModal();
      return;
    }

    final userId = authService.currentUser!.id;
    final updatedDoc = _document.copyWith(
      ownerId: userId,
      title: _titleEditingController.text,
      rawText: _textEditingController.text,
      updatedAt: DateTime.now(),
    );

    await _storageService.saveDocument(updatedDoc);
    setState(() => _document = updatedDoc);

    if (mounted) {
      AppToast.show(context, 'Document saved to My Library.');
    }
  }

  void _promptLoginModal() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTokens.colorBgSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: AppTokens.borderRadiusMd,
          side: BorderSide(color: AppTokens.colorBorderDefault),
        ),
        title: const Text(
          'Sign in to save document',
          style: TextStyle(
            color: AppTokens.colorTextPrimary,
            fontSize: AppTokens.fontSizeLg,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'Guest scans are temporary. Sign in or create a free account to permanently save this document and your custom fonts.',
          style: TextStyle(
            color: AppTokens.colorTextSecondary,
            fontSize: AppTokens.fontSizeSm,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Stay in guest mode'),
          ),
          AppButton(
            text: 'Sign in',
            variant: AppButtonVariant.primary,
            onPressed: () {
              Navigator.pop(ctx);
              widget.onNavigate('/login');
            },
          ),
        ],
      ),
    );
  }

  Future<void> _savePreferencesAsDefault() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    if (!authService.isLoggedIn) {
      _promptLoginModal();
      return;
    }

    final userId = authService.currentUser!.id;
    final updatedPrefs = _preferences.copyWith(ownerId: userId);
    await _storageService.saveUserPreferences(updatedPrefs);

    if (mounted) {
      AppToast.show(context, 'Display preferences saved as your personal default.');
    }
  }

  @override
  void dispose() {
    _ttsService.dispose();
    _textEditingController.dispose();
    _titleEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingPreferences) {
      return const Center(child: CircularProgressIndicator(color: AppTokens.colorAccentPrimary));
    }

    final authService = context.watch<AuthService>();
    final isMobile = MediaQuery.of(context).size.width < 768;

    return ListenableBuilder(
      listenable: _ttsService,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppTokens.colorBgCanvas,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? AppTokens.space3 : AppTokens.space6,
                vertical: AppTokens.space3,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1040),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Navigation & Action Row
                    _buildTopActionBar(authService.isLoggedIn, isMobile),

                    const SizedBox(height: AppTokens.space3),

                    // First-class Collapsible Display Settings Panel
                    if (_showSettingsPanel) ...[
                      DisplaySettingsPanel(
                        preferences: _preferences,
                        isLoggedIn: authService.isLoggedIn,
                        showLivePreview: false, // Live preview is already the main reading canvas!
                        onChanged: (newPrefs) {
                          setState(() => _preferences = newPrefs);
                        },
                        onSaveDefault: _savePreferencesAsDefault,
                        onResetDefaults: () {
                          setState(() {
                            _preferences = UserPreferences.defaultPreferences();
                          });
                        },
                      ),
                      const SizedBox(height: AppTokens.space4),
                    ],

                    // Document Title & Metadata
                    _buildDocumentHeader(isMobile),

                    const SizedBox(height: AppTokens.space3),

                    // Dyslexia Reading Canvas
                    DyslexiaTextRenderer(
                      text: _document.rawText,
                      preferences: _preferences,
                      activeWordIndex: _ttsService.currentWordIndex,
                      isEditing: _isEditing,
                      editController: _textEditingController,
                      onWordTap: (wordIdx) {
                        _ttsService.seekToWord(wordIdx);
                      },
                    ),

                    const SizedBox(height: AppTokens.space4),

                    // Persistent Audio TTS Player
                    TTSPlayer(
                      ttsService: _ttsService,
                      textToSpeak: _document.rawText,
                    ),

                    const SizedBox(height: AppTokens.space6),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopActionBar(bool isLoggedIn, bool isMobile) {
    return Wrap(
      spacing: AppTokens.space2,
      runSpacing: AppTokens.space2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AppButton(
          text: isMobile ? '' : 'Scan text',
          icon: Icons.arrow_back_rounded,
          variant: AppButtonVariant.secondary,
          onPressed: () => widget.onNavigate('/app'),
          semanticLabel: 'Back to scan page',
        ),
        AppButton(
          text: isMobile ? 'Display' : 'Display settings',
          icon: Icons.tune_rounded,
          variant: _showSettingsPanel ? AppButtonVariant.primary : AppButtonVariant.secondary,
          onPressed: () => setState(() => _showSettingsPanel = !_showSettingsPanel),
          semanticLabel: 'Toggle reading font, spacing, and overlay controls',
        ),
        if (!_isEditing)
          AppButton(
            text: isMobile ? 'Edit' : 'Edit text',
            icon: Icons.edit_note_rounded,
            variant: AppButtonVariant.ghost,
            onPressed: () => setState(() => _isEditing = true),
          )
        else
          AppButton(
            text: 'Save text',
            icon: Icons.check_rounded,
            variant: AppButtonVariant.primary,
            onPressed: _saveCurrentText,
          ),
        AppButton(
          text: isLoggedIn ? 'Save document' : 'Save to library',
          icon: Icons.bookmark_add_outlined,
          variant: AppButtonVariant.primary,
          onPressed: _saveDocumentToLibrary,
        ),
      ],
    );
  }

  Widget _buildDocumentHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isEditing)
          TextField(
            controller: _titleEditingController,
            style: const TextStyle(
              color: AppTokens.colorTextPrimary,
              fontSize: AppTokens.fontSize2xl,
              fontWeight: FontWeight.w700,
            ),
            decoration: const InputDecoration(
              hintText: 'Document title…',
              labelText: 'Title',
            ),
          )
        else
          Text(
            _document.title,
            style: const TextStyle(
              color: AppTokens.colorTextPrimary,
              fontSize: AppTokens.fontSize2xl,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
        const SizedBox(height: AppTokens.space1),
        Wrap(
          spacing: AppTokens.space2,
          runSpacing: AppTokens.space1,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppBadge(
              text: _document.source == 'camera' ? 'Camera scan' : 'Uploaded file',
              icon: _document.source == 'camera' ? Icons.camera_alt : Icons.upload_file,
            ),
            AppBadge(
              text: 'Font: ${_preferences.fontFamily}',
              backgroundColor: AppTokens.colorBgSurfaceMuted,
            ),
            if (_preferences.overlayColor != null)
              AppBadge(
                text: 'Overlay: ${_preferences.overlayColor}',
                backgroundColor: AppTokens.colorBgSurfaceMuted,
              ),
            IconButton(
              icon: const Icon(Icons.copy_rounded, size: 16, color: AppTokens.colorTextSecondary),
              tooltip: 'Copy text to clipboard',
              constraints: const BoxConstraints(
                minWidth: AppTokens.minTouchTarget,
                minHeight: AppTokens.minTouchTarget,
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _document.rawText));
                AppToast.show(context, 'Text copied to clipboard.');
              },
            ),
          ],
        ),
      ],
    );
  }
}
