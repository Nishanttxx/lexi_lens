import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_tokens.dart';
import '../common/app_badge.dart';
import '../common/app_button.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String activeRoute;
  final Function(String route) onNavigate;

  const AppHeader({
    super.key,
    required this.activeRoute,
    required this.onNavigate,
  });

  @override
  Size get preferredSize => const Size.fromHeight(68.0);

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final isLoggedIn = authService.isLoggedIn;
    final user = authService.currentUser;
    final isMobile = MediaQuery.of(context).size.width < 860;

    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: AppTokens.space3),
      decoration: const BoxDecoration(
        color: AppTokens.colorBgSurfaceMuted,
        border: Border(
          bottom: BorderSide(color: AppTokens.colorBorderDefault, width: 1.0),
        ),
        boxShadow: AppTokens.shadow1,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Brand Logo & Title
            InkWell(
              onTap: () => onNavigate('/'),
              borderRadius: AppTokens.borderRadiusSm,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.space2,
                  vertical: AppTokens.space1,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTokens.colorAccentPrimary,
                        borderRadius: AppTokens.borderRadiusSm,
                        boxShadow: AppTokens.shadow1,
                      ),
                      child: const Icon(
                        Icons.visibility_rounded,
                        color: AppTokens.colorTextInverse,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: AppTokens.space2),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lexi Lens',
                          style: TextStyle(
                            color: AppTokens.colorTextPrimary,
                            fontSize: AppTokens.fontSizeLg,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                        if (!isMobile)
                          const Text(
                            'Calm, accessible reading & audio',
                            style: TextStyle(
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

            const Spacer(),

            // Desktop Navigation links
            if (!isMobile) ...[
              _HeaderNavLink(
                label: 'Scan text',
                icon: Icons.document_scanner_outlined,
                isActive: activeRoute == '/app' || activeRoute == '/home' || activeRoute == '/dashboard',
                onTap: () => onNavigate('/app'),
              ),
              const SizedBox(width: AppTokens.space1),
              _HeaderNavLink(
                label: 'My Library',
                icon: Icons.bookmarks_outlined,
                isActive: activeRoute == '/library',
                onTap: () => onNavigate('/library'),
              ),
              const SizedBox(width: AppTokens.space1),
              _HeaderNavLink(
                label: 'Display settings',
                icon: Icons.tune_rounded,
                isActive: activeRoute == '/settings',
                onTap: () => onNavigate('/settings'),
              ),
              const SizedBox(width: AppTokens.space3),
              const SizedBox(
                height: 24,
                child: VerticalDivider(color: AppTokens.colorBorderDefault),
              ),
              const SizedBox(width: AppTokens.space3),
            ],

            // Session Info & Auth Button
            if (isLoggedIn) ...[
              if (activeRoute == '/') ...[
                AppButton(
                  text: isMobile ? 'Start' : 'Start exploring',
                  icon: Icons.arrow_forward_rounded,
                  variant: AppButtonVariant.primary,
                  onPressed: () => onNavigate('/app'),
                  semanticLabel: 'Start exploring Lexi Lens app',
                ),
                const SizedBox(width: AppTokens.space2),
              ],
              if (!isMobile) ...[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      user?.displayName ?? user?.email ?? 'Member',
                      style: const TextStyle(
                        color: AppTokens.colorTextPrimary,
                        fontSize: AppTokens.fontSizeSm,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const AppBadge(
                      text: 'Logged in',
                      backgroundColor: Color(0xFFEAF5EF),
                      textColor: AppTokens.colorStateSuccess,
                      borderColor: AppTokens.colorStateSuccess,
                    ),
                  ],
                ),
                const SizedBox(width: AppTokens.space2),
              ],
              AppButton(
                text: isMobile ? '' : 'Log out',
                icon: Icons.logout_rounded,
                variant: AppButtonVariant.secondary,
                onPressed: () async {
                  await authService.logout();
                  onNavigate('/');
                },
                semanticLabel: 'Log out of Lexi Lens',
              ),
            ] else ...[
              if (activeRoute == '/') ...[
                AppButton(
                  text: isMobile ? 'Start' : 'Start exploring',
                  icon: Icons.arrow_forward_rounded,
                  variant: AppButtonVariant.primary,
                  onPressed: () => onNavigate('/app'),
                  semanticLabel: 'Start exploring Lexi Lens app',
                ),
                const SizedBox(width: AppTokens.space2),
              ],
              if (!isMobile) ...[
                const AppBadge(
                  text: 'Guest mode',
                  backgroundColor: AppTokens.colorBgSurface,
                  textColor: AppTokens.colorTextSecondary,
                  borderColor: AppTokens.colorBorderDefault,
                ),
                const SizedBox(width: AppTokens.space2),
              ],
              AppButton(
                text: 'Sign in',
                icon: Icons.login_rounded,
                variant: activeRoute == '/' ? AppButtonVariant.secondary : AppButtonVariant.primary,
                onPressed: () => onNavigate('/login'),
              ),
            ],

            // Mobile menu button
            if (isMobile) ...[
              const SizedBox(width: AppTokens.space2),
              PopupMenuButton<String>(
                icon: const Icon(Icons.menu_rounded, color: AppTokens.colorTextPrimary),
                color: AppTokens.colorBgSurface,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppTokens.borderRadiusSm,
                  side: BorderSide(color: AppTokens.colorBorderDefault),
                ),
                onSelected: (route) => onNavigate(route),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: '/app',
                    child: Row(
                      children: [
                        Icon(Icons.document_scanner_outlined, size: 18, color: AppTokens.colorAccentPrimary),
                        SizedBox(width: AppTokens.space2),
                        Text('Scan text', style: TextStyle(color: AppTokens.colorTextPrimary)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: '/library',
                    child: Row(
                      children: [
                        Icon(Icons.bookmarks_outlined, size: 18, color: AppTokens.colorAccentPrimary),
                        SizedBox(width: AppTokens.space2),
                        Text('My Library', style: TextStyle(color: AppTokens.colorTextPrimary)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: '/settings',
                    child: Row(
                      children: [
                        Icon(Icons.tune_rounded, size: 18, color: AppTokens.colorAccentPrimary),
                        SizedBox(width: AppTokens.space2),
                        Text('Display settings', style: TextStyle(color: AppTokens.colorTextPrimary)),
                      ],
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

class _HeaderNavLink extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _HeaderNavLink({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_HeaderNavLink> createState() => _HeaderNavLinkState();
}

class _HeaderNavLinkState extends State<_HeaderNavLink> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final fg = widget.isActive
        ? AppTokens.colorAccentPrimary
        : (_isHovered ? AppTokens.colorTextPrimary : AppTokens.colorTextSecondary);

    return Semantics(
      button: true,
      selected: widget.isActive,
      label: widget.label,
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
              color: widget.isActive
                  ? AppTokens.colorBgSurface
                  : (_isHovered ? AppTokens.colorBgSurface.withValues(alpha: 0.6) : Colors.transparent),
              borderRadius: AppTokens.borderRadiusSm,
              border: _isFocused
                  ? Border.all(color: AppTokens.colorStateFocus, width: 2.0)
                  : (widget.isActive
                      ? Border.all(color: AppTokens.colorAccentPrimary.withValues(alpha: 0.4), width: 1.0)
                      : null),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 18, color: fg),
                const SizedBox(width: AppTokens.space2),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: fg,
                    fontSize: AppTokens.fontSizeSm,
                    fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
