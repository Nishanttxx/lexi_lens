import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/models/document_model.dart';
import '../core/services/auth_service.dart';
import '../core/services/storage_service.dart';
import '../core/theme/app_tokens.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/common/toast.dart';
import '../widgets/library/document_card.dart';

class LibraryScreen extends StatefulWidget {
  final Function(String route, {Map<String, dynamic>? arguments}) onNavigate;

  const LibraryScreen({super.key, required this.onNavigate});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final StorageService _storageService = StorageService();
  List<DocumentModel> _documents = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    setState(() => _isLoading = true);
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.currentUser?.id ?? 'default_user';

    final docs = await _storageService.getDocuments(userId: userId);
    if (mounted) {
      setState(() {
        _documents = docs;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteDocument(DocumentModel doc) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTokens.colorBgSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: AppTokens.borderRadiusMd,
          side: BorderSide(color: AppTokens.colorBorderDefault),
        ),
        title: const Text(
          'Delete document?',
          style: TextStyle(
            color: AppTokens.colorTextPrimary,
            fontSize: AppTokens.fontSizeLg,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Are you sure you want to remove "${doc.title}"? This item will be removed from your saved library.',
          style: const TextStyle(
            color: AppTokens.colorTextSecondary,
            fontSize: AppTokens.fontSizeSm,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'Delete',
            variant: AppButtonVariant.destructive,
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      if (!mounted) return;
      final authService = Provider.of<AuthService>(context, listen: false);
      final userId = authService.currentUser?.id ?? 'default_user';
      await _storageService.softDeleteDocument(doc.id, userId: userId);
      await _loadDocuments();
      if (mounted) {
        AppToast.show(context, 'Document deleted.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final isGuest = authService.isGuest;
    final isMobile = MediaQuery.of(context).size.width < 768;

    if (isGuest && !authService.isLoggedIn) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.space4),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: EmptyState(
              icon: Icons.lock_outline_rounded,
              title: 'Personal library requires sign in',
              description:
                  'Guest scans are temporary. Sign in or register for a free account to permanently organize and access your scanned documents across devices.',
              actionText: 'Sign in to Lexi Lens',
              actionIcon: Icons.login_rounded,
              onAction: () => widget.onNavigate('/login'),
            ),
          ),
        ),
      );
    }

    final filteredDocs = _documents.where((doc) {
      if (_searchQuery.trim().isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      return doc.title.toLowerCase().contains(query) ||
          doc.rawText.toLowerCase().contains(query);
    }).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? AppTokens.space3 : AppTokens.space6,
          vertical: AppTokens.space4,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header & Action Bar
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'My Documents',
                            style: TextStyle(
                              color: AppTokens.colorTextPrimary,
                              fontSize: AppTokens.fontSize2xl,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_documents.length} saved ${_documents.length == 1 ? 'document' : 'documents'}',
                            style: const TextStyle(
                              color: AppTokens.colorTextSecondary,
                              fontSize: AppTokens.fontSizeSm,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppButton(
                      text: isMobile ? 'Scan' : 'Scan new document',
                      icon: Icons.add_rounded,
                      variant: AppButtonVariant.primary,
                      onPressed: () => widget.onNavigate('/app'),
                    ),
                  ],
                ),

                const SizedBox(height: AppTokens.space4),

                // Search / Filter Input
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: const TextStyle(
                    color: AppTokens.colorTextPrimary,
                    fontSize: AppTokens.fontSizeSm,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search documents by title or text…',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppTokens.colorTextSecondary,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18, color: AppTokens.colorTextSecondary),
                            onPressed: () => setState(() => _searchQuery = ''),
                            tooltip: 'Clear search',
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: AppTokens.space4),

                // Content Area
                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppTokens.space6),
                      child: CircularProgressIndicator(color: AppTokens.colorAccentPrimary),
                    ),
                  )
                else if (filteredDocs.isEmpty)
                  EmptyState(
                    icon: Icons.bookmarks_outlined,
                    title: _searchQuery.isNotEmpty
                        ? 'No matching documents'
                        : "You haven't scanned anything yet",
                    description: _searchQuery.isNotEmpty
                        ? 'No documents matched "$_searchQuery". Try another keyword or scan a new page.'
                        : 'Point your camera at a printed book, worksheet, or sign to begin reading.',
                    actionText: _searchQuery.isNotEmpty ? 'Clear search' : 'Scan text',
                    actionIcon: _searchQuery.isNotEmpty ? Icons.clear : Icons.camera_alt_outlined,
                    onAction: () {
                      if (_searchQuery.isNotEmpty) {
                        setState(() => _searchQuery = '');
                      } else {
                        widget.onNavigate('/app');
                      }
                    },
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredDocs.length,
                    separatorBuilder: (_, _) => const SizedBox(height: AppTokens.space3),
                    itemBuilder: (context, index) {
                      final doc = filteredDocs[index];
                      return DocumentCard(
                        document: doc,
                        onOpen: () {
                          widget.onNavigate('/read', arguments: {'document': doc});
                        },
                        onDelete: () => _deleteDocument(doc),
                      );
                    },
                  ),

                const SizedBox(height: AppTokens.space6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
