import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/auth_service.dart';
import '../core/theme/app_tokens.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../widgets/common/app_input.dart';
import '../widgets/common/error_banner.dart';
import '../widgets/common/toast.dart';

class AuthScreen extends StatefulWidget {
  final bool initialIsSignUp;
  final Function(String route, {Map<String, dynamic>? arguments}) onNavigate;

  const AuthScreen({
    super.key,
    this.initialIsSignUp = false,
    required this.onNavigate,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool _isSignUp;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _isSignUp = widget.initialIsSignUp;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool isValid = true;
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _emailError = 'Please enter a valid email address.');
      isValid = false;
    }

    final password = _passwordController.text;
    if (password.length < 6) {
      setState(() => _passwordError = 'Password must be at least 6 characters.');
      isValid = false;
    }

    return isValid;
  }

  Future<void> _submit() async {
    if (!_validate()) return;

    final authService = Provider.of<AuthService>(context, listen: false);
    bool success;

    if (_isSignUp) {
      success = await authService.signup(
        _emailController.text,
        _passwordController.text,
        displayName: _nameController.text,
      );
    } else {
      success = await authService.login(
        _emailController.text,
        _passwordController.text,
      );
    }

    if (success && mounted) {
      AppToast.show(
        context,
        _isSignUp ? 'Account created! Welcome to Lexi Lens.' : 'Welcome back to Lexi Lens.',
      );
      widget.onNavigate('/app');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final authError = authService.authError;
    final isLoading = authService.isLoading;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.space4),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: AppCard(
              padding: const EdgeInsets.all(AppTokens.space5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Icon & Heading
                  Center(
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: AppTokens.colorAccentPrimary,
                        borderRadius: AppTokens.borderRadiusSm,
                        boxShadow: AppTokens.shadow1,
                      ),
                      child: const Icon(
                        Icons.visibility_rounded,
                        color: AppTokens.colorTextInverse,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTokens.space3),
                  Text(
                    _isSignUp ? 'Create your Lexi Lens account' : 'Welcome back',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTokens.colorTextPrimary,
                      fontSize: AppTokens.fontSize2xl,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppTokens.space1),
                  Text(
                    _isSignUp
                        ? 'Save your custom dyslexia fonts, color tints, and scanned library across all devices.'
                        : 'Sign in to access your saved reading documents and personalized defaults.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTokens.colorTextSecondary,
                      fontSize: AppTokens.fontSizeSm,
                      height: 1.4,
                    ),
                  ),

                  if (authError != null) ...[
                    const SizedBox(height: AppTokens.space3),
                    ErrorBanner(
                      title: 'Sign in notice',
                      message: authError,
                    ),
                  ],

                  const SizedBox(height: AppTokens.space4),

                  if (_isSignUp) ...[
                    AppInput(
                      label: 'Your name',
                      controller: _nameController,
                      hint: 'Alex Smith',
                      prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                    ),
                    const SizedBox(height: AppTokens.space3),
                  ],

                  AppInput(
                    label: 'Email address',
                    controller: _emailController,
                    hint: 'you@example.com',
                    keyboardType: TextInputType.emailAddress,
                    errorText: _emailError,
                    prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20),
                  ),

                  const SizedBox(height: AppTokens.space3),

                  AppInput(
                    label: 'Password',
                    controller: _passwordController,
                    isPassword: true,
                    hint: '••••••••',
                    errorText: _passwordError,
                    prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                    onSubmitted: (_) => _submit(),
                  ),

                  if (!_isSignUp) ...[
                    const SizedBox(height: AppTokens.space1),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => widget.onNavigate('/reset-password'),
                        child: const Text('Forgot password?'),
                      ),
                    ),
                  ] else
                    const SizedBox(height: AppTokens.space3),

                  const SizedBox(height: AppTokens.space2),

                  AppButton(
                    text: _isSignUp ? 'Sign up' : 'Log in',
                    isLoading: isLoading,
                    isFullWidth: true,
                    onPressed: isLoading ? null : _submit,
                  ),

                  const SizedBox(height: AppTokens.space3),

                  // Toggle between Login & Signup
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isSignUp ? 'Already have an account?' : "Don't have an account?",
                        style: const TextStyle(
                          color: AppTokens.colorTextSecondary,
                          fontSize: AppTokens.fontSizeSm,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isSignUp = !_isSignUp;
                            _emailError = null;
                            _passwordError = null;
                          });
                        },
                        child: Text(_isSignUp ? 'Log in' : 'Sign up'),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTokens.space2),
                  const Divider(color: AppTokens.colorBorderDefault),
                  const SizedBox(height: AppTokens.space2),

                  // Guest Flow CTA
                  AppButton(
                    text: 'Continue as guest',
                    variant: AppButtonVariant.secondary,
                    icon: Icons.person_outline_rounded,
                    isFullWidth: true,
                    onPressed: () async {
                      await authService.continueAsGuest();
                      widget.onNavigate('/app');
                    },
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
