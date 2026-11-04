import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/auth_service.dart';
import '../core/theme/app_tokens.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../widgets/common/app_input.dart';
import '../widgets/common/toast.dart';

class ResetPasswordScreen extends StatefulWidget {
  final Function(String route, {Map<String, dynamic>? arguments}) onNavigate;

  const ResetPasswordScreen({super.key, required this.onNavigate});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isSent = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _error = 'Please enter a valid email address.');
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);
    final success = await authService.resetPassword(email);

    if (success && mounted) {
      setState(() {
        _isSent = true;
        _error = null;
      });
      AppToast.show(context, 'Reset instructions sent to $email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.space4),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: AppCard(
              padding: const EdgeInsets.all(AppTokens.space5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppTokens.colorBgSurfaceMuted,
                        borderRadius: AppTokens.borderRadiusSm,
                        border: Border.all(color: AppTokens.colorBorderDefault),
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        color: AppTokens.colorAccentPrimary,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTokens.space3),
                  const Text(
                    'Reset your password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTokens.colorTextPrimary,
                      fontSize: AppTokens.fontSize2xl,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppTokens.space1),
                  Text(
                    _isSent
                        ? 'Check your inbox for a secure password reset link.'
                        : 'Enter the email address linked to your Lexi Lens account and we will send you recovery instructions.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTokens.colorTextSecondary,
                      fontSize: AppTokens.fontSizeSm,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppTokens.space4),

                  if (!_isSent) ...[
                    AppInput(
                      label: 'Account email',
                      controller: _emailController,
                      hint: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                      errorText: _error,
                      prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20),
                      onSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: AppTokens.space4),
                    AppButton(
                      text: 'Send reset link',
                      isFullWidth: true,
                      onPressed: _submit,
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(AppTokens.space3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF5EF),
                        borderRadius: AppTokens.borderRadiusSm,
                        border: Border.all(color: AppTokens.colorStateSuccess),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: AppTokens.colorStateSuccess),
                          const SizedBox(width: AppTokens.space2),
                          Expanded(
                            child: Text(
                              'Email sent to ${_emailController.text}. Follow the link to choose a new password.',
                              style: const TextStyle(
                                color: AppTokens.colorTextPrimary,
                                fontSize: AppTokens.fontSizeSm,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTokens.space4),
                  ],

                  const SizedBox(height: AppTokens.space2),
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_back_rounded, size: 16),
                    label: const Text('Back to sign in'),
                    onPressed: () => widget.onNavigate('/login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
