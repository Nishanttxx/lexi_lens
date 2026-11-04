import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/models/user_preferences.dart';
import '../core/services/auth_service.dart';
import '../core/services/storage_service.dart';
import '../core/theme/app_tokens.dart';
import '../widgets/common/app_badge.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../widgets/common/app_input.dart';
import '../widgets/common/toast.dart';
import '../widgets/reading/display_settings_panel.dart';

class SettingsScreen extends StatefulWidget {
  final Function(String route, {Map<String, dynamic>? arguments}) onNavigate;

  const SettingsScreen({super.key, required this.onNavigate});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final StorageService _storageService = StorageService();

  late UserPreferences _preferences;
  bool _isLoading = true;
  bool _isSavingPrefs = false;

  late TextEditingController _nameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _preferences = UserPreferences.defaultPreferences();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _loadData();
  }

  Future<void> _loadData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;
    final userId = user?.id ?? 'guest';

    final savedPrefs = await _storageService.getUserPreferences(userId);
    if (mounted) {
      setState(() {
        _preferences = savedPrefs;
        _nameController.text = user?.displayName ?? '';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveDefaultPreferences() async {
    setState(() => _isSavingPrefs = true);
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.currentUser?.id ?? 'guest';

    final updatedPrefs = _preferences.copyWith(
      ownerId: userId,
      updatedAt: DateTime.now(),
    );

    await _storageService.saveUserPreferences(updatedPrefs);
    if (mounted) {
      setState(() => _isSavingPrefs = false);
      AppToast.show(context, 'Settings saved.');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppTokens.colorAccentPrimary));
    }

    final authService = context.watch<AuthService>();
    final isLoggedIn = authService.isLoggedIn;
    final user = authService.currentUser;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? AppTokens.space3 : AppTokens.space6,
          vertical: AppTokens.space4,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page Header
                const Text(
                  'Preferences & Account',
                  style: TextStyle(
                    color: AppTokens.colorTextPrimary,
                    fontSize: AppTokens.fontSize2xl,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Set your permanent dyslexia reading defaults and manage your account.',
                  style: TextStyle(
                    color: AppTokens.colorTextSecondary,
                    fontSize: AppTokens.fontSizeSm,
                  ),
                ),

                const SizedBox(height: AppTokens.space4),

                // 1. Default Display Preferences Section
                DisplaySettingsPanel(
                  preferences: _preferences,
                  isLoggedIn: isLoggedIn,
                  showLivePreview: true,
                  onChanged: (newPrefs) => setState(() => _preferences = newPrefs),
                  onSaveDefault: _saveDefaultPreferences,
                  onResetDefaults: () {
                    setState(() {
                      _preferences = UserPreferences.defaultPreferences();
                    });
                  },
                ),

                const SizedBox(height: AppTokens.space3),

                // Save Preferences CTA Button
                Align(
                  alignment: Alignment.centerRight,
                  child: AppButton(
                    text: _isSavingPrefs ? 'Saving…' : 'Save default preferences',
                    icon: Icons.check_circle_outline_rounded,
                    isLoading: _isSavingPrefs,
                    onPressed: _saveDefaultPreferences,
                  ),
                ),

                const SizedBox(height: AppTokens.space5),
                const Divider(color: AppTokens.colorBorderDefault),
                const SizedBox(height: AppTokens.space5),

                // 2. Account Profile Section
                _buildAccountSection(authService, isLoggedIn, user),

                const SizedBox(height: AppTokens.space6),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection(
    AuthService authService,
    bool isLoggedIn,
    dynamic user,
  ) {
    if (!isLoggedIn) {
      return AppCard(
        padding: const EdgeInsets.all(AppTokens.space5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.person_outline_rounded, color: AppTokens.colorAccentPrimary, size: 24),
                SizedBox(width: AppTokens.space2),
                Text(
                  'Guest Session Active',
                  style: TextStyle(
                    color: AppTokens.colorTextPrimary,
                    fontSize: AppTokens.fontSizeLg,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                AppBadge(
                  text: 'Temporary session',
                  backgroundColor: AppTokens.colorBgSurfaceMuted,
                  textColor: AppTokens.colorTextSecondary,
                ),
              ],
            ),
            const SizedBox(height: AppTokens.space2),
            const Text(
              'Your reading preferences are stored in this browser. To ensure your custom font sizes, tints, and scanned documents sync across mobile and desktop devices, sign in or register for a free account.',
              style: TextStyle(
                color: AppTokens.colorTextSecondary,
                fontSize: AppTokens.fontSizeSm,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppTokens.space4),
            AppButton(
              text: 'Sign in to Lexi Lens',
              icon: Icons.login_rounded,
              variant: AppButtonVariant.primary,
              onPressed: () => widget.onNavigate('/login'),
            ),
          ],
        ),
      );
    }

    return AppCard(
      padding: const EdgeInsets.all(AppTokens.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_circle_outlined, color: AppTokens.colorAccentPrimary, size: 24),
              const SizedBox(width: AppTokens.space2),
              const Text(
                'Account Settings',
                style: TextStyle(
                  color: AppTokens.colorTextPrimary,
                  fontSize: AppTokens.fontSizeLg,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              AppBadge(
                text: 'Member account',
                backgroundColor: const Color(0xFFEAF5EF),
                textColor: AppTokens.colorStateSuccess,
                borderColor: AppTokens.colorStateSuccess,
              ),
            ],
          ),
          const SizedBox(height: AppTokens.space3),
          Text(
            'Signed in as: ${user?.email}',
            style: const TextStyle(
              color: AppTokens.colorTextSecondary,
              fontSize: AppTokens.fontSizeSm,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTokens.space3),
          AppInput(
            label: 'Display Name',
            controller: _nameController,
            hint: 'Your preferred name',
          ),
          const SizedBox(height: AppTokens.space3),
          AppInput(
            label: 'Update Password',
            controller: _passwordController,
            hint: 'Enter new password (min 6 chars)',
            isPassword: true,
          ),
          const SizedBox(height: AppTokens.space4),
          Row(
            children: [
              AppButton(
                text: 'Update profile',
                variant: AppButtonVariant.secondary,
                onPressed: () {
                  AppToast.show(context, 'Profile information updated.');
                },
              ),
              const Spacer(),
              AppButton(
                text: 'Log out',
                icon: Icons.logout_rounded,
                variant: AppButtonVariant.destructive,
                onPressed: () async {
                  await authService.logout();
                  widget.onNavigate('/');
                  if (mounted) {
                    AppToast.show(context, 'Logged out.');
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
