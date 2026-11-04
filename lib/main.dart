import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/auth_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_tokens.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/library_screen.dart';
import 'screens/reading_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/scan_processing_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/navigation/app_header.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LexiLensApp());
}

class LexiLensApp extends StatelessWidget {
  const LexiLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Lexi Lens — Calm & Accessible Reading',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.warmTheme,
        home: const MainAppShell(),
      ),
    );
  }
}

class MainAppShell extends StatefulWidget {
  const MainAppShell({super.key});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  String _currentRoute = '/';
  Map<String, dynamic> _currentArguments = {};

  void _navigateTo(String route, {Map<String, dynamic>? arguments}) {
    setState(() {
      _currentRoute = route;
      _currentArguments = arguments ?? {};
    });
  }

  Widget _buildCurrentScreen() {
    switch (_currentRoute) {
      case '/':
        return LandingScreen(onNavigate: _navigateTo);
      case '/app':
      case '/home':
      case '/dashboard':
        return HomeScreen(onNavigate: _navigateTo);
      case '/scan/processing':
        return ScanProcessingScreen(
          arguments: _currentArguments,
          onNavigate: _navigateTo,
        );
      case '/read':
        return ReadingScreen(
          arguments: _currentArguments,
          onNavigate: _navigateTo,
        );
      case '/library':
        return LibraryScreen(onNavigate: _navigateTo);
      case '/settings':
        return SettingsScreen(onNavigate: _navigateTo);
      case '/login':
        return AuthScreen(
          initialIsSignUp: false,
          onNavigate: _navigateTo,
        );
      case '/signup':
        return AuthScreen(
          initialIsSignUp: true,
          onNavigate: _navigateTo,
        );
      case '/reset-password':
        return ResetPasswordScreen(onNavigate: _navigateTo);
      default:
        return HomeScreen(onNavigate: _navigateTo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.maybeOf(context);
    final reduceMotion = media?.disableAnimations ?? false;

    return Scaffold(
      backgroundColor: AppTokens.colorBgCanvas,
      appBar: AppHeader(
        activeRoute: _currentRoute,
        onNavigate: _navigateTo,
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: AnimatedSwitcher(
          duration: reduceMotion ? Duration.zero : AppTokens.durationFast,
          child: KeyedSubtree(
            key: ValueKey(_currentRoute),
            child: _buildCurrentScreen(),
          ),
        ),
      ),
    );
  }
}
