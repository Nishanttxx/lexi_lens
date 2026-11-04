import 'package:flutter/material.dart';
import '../../core/models/document_model.dart';
import '../../core/theme/app_tokens.dart';
import '../common/app_badge.dart';

class DocumentCard extends StatefulWidget {
  final DocumentModel document;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  const DocumentCard({
    super.key,
    required this.document,
    required this.onOpen,
    required this.onDelete,
  });

  @override
  State<DocumentCard> createState() => _DocumentCardState();
}

class _DocumentCardState extends State<DocumentCard> {
  bool _isHovered = false;
  bool _isFocused = false;

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCamera = widget.document.source == 'camera';
    final previewText = widget.document.rawText.trim().split('\n').first;

    return Semantics(
      button: true,
      label: 'Document: ${widget.document.title}. Scanned ${widget.document.source}. Tap to read and listen.',
      child: FocusableActionDetector(
        onShowFocusHighlight: (v) => setState(() => _isFocused = v),
        onShowHoverHighlight: (v) => setState(() => _isHovered = v),
        mouseCursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onOpen,
          child: AnimatedContainer(
            duration: AppTokens.durationFast,
            padding: const EdgeInsets.all(AppTokens.space4),
            decoration: BoxDecoration(
              color: _isHovered ? AppTokens.colorBgSurfaceMuted : AppTokens.colorBgSurface,
              borderRadius: AppTokens.borderRadiusMd,
              border: Border.all(
                color: _isFocused
                    ? AppTokens.colorStateFocus
                    : (_isHovered ? AppTokens.colorBorderStrong : AppTokens.colorBorderDefault),
                width: _isFocused ? 2.0 : 1.0,
              ),
              boxShadow: _isHovered ? AppTokens.shadow2 : AppTokens.shadow1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isCamera
                            ? AppTokens.colorAccentPrimary.withValues(alpha: 0.12)
                            : AppTokens.colorAccentWarm.withValues(alpha: 0.15),
                        borderRadius: AppTokens.borderRadiusSm,
                      ),
                      child: Icon(
                        isCamera ? Icons.camera_alt_outlined : Icons.description_outlined,
                        size: 20,
                        color: isCamera ? AppTokens.colorAccentPrimary : AppTokens.colorAccentWarm,
                      ),
                    ),
                    const SizedBox(width: AppTokens.space3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Long titles wrap to two lines then truncate per DESIGN.md
                          Tooltip(
                            message: widget.document.title,
                            child: Text(
                              widget.document.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppTokens.colorTextPrimary,
                                fontSize: AppTokens.fontSizeMd,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDate(widget.document.createdAt),
                            style: const TextStyle(
                              color: AppTokens.colorTextSecondary,
                              fontSize: AppTokens.fontSizeXs,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded, color: AppTokens.colorTextSecondary),
                      color: AppTokens.colorBgSurface,
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppTokens.borderRadiusSm,
                        side: BorderSide(color: AppTokens.colorBorderDefault),
                      ),
                      tooltip: 'Document options',
                      onSelected: (val) {
                        if (val == 'open') widget.onOpen();
                        if (val == 'delete') widget.onDelete();
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'open',
                          child: Row(
                            children: [
                              Icon(Icons.auto_stories_outlined, size: 18, color: AppTokens.colorAccentPrimary),
                              SizedBox(width: AppTokens.space2),
                              Text('Read & listen', style: TextStyle(color: AppTokens.colorTextPrimary)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline_rounded, size: 18, color: AppTokens.colorStateError),
                              SizedBox(width: AppTokens.space2),
                              Text('Delete document', style: TextStyle(color: AppTokens.colorStateError)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppTokens.space2),
                Text(
                  previewText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTokens.colorTextSecondary,
                    fontSize: AppTokens.fontSizeSm,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppTokens.space3),
                Row(
                  children: [
                    AppBadge(
                      text: isCamera ? 'Camera scan' : 'Uploaded file',
                      icon: isCamera ? Icons.camera_alt : Icons.upload_file,
                    ),
                    const SizedBox(width: AppTokens.space2),
                    AppBadge(
                      text: '${(widget.document.confidence * 100).round()}% OCR accuracy',
                      textColor: AppTokens.colorStateSuccess,
                      borderColor: AppTokens.colorStateSuccess.withValues(alpha: 0.4),
                      backgroundColor: const Color(0xFFEAF5EF),
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
