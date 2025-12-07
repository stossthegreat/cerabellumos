import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/main_screen.dart';
import 'providers/app_state.dart';
import 'providers/study_targets_provider.dart';
import 'providers/projects_provider.dart';
import 'companion/companion_controller.dart';
import 'core/design_tokens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Force portrait mode and set status bar
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: DesignTokens.backgroundPrimary,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const CerebellumOS());
}

class CerebellumOS extends StatelessWidget {
  const CerebellumOS({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => StudyTargetsProvider()),
        ChangeNotifierProvider(create: (_) => ProjectsProvider()),
        ChangeNotifierProvider(create: (_) => CompanionController()),
      ],
      child: MaterialApp(
        title: 'CerebellumOS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: DesignTokens.backgroundPrimary,
          primaryColor: DesignTokens.primary,
          colorScheme: ColorScheme.dark(
            primary: DesignTokens.primary,
            secondary: DesignTokens.secondary,
            surface: DesignTokens.surfaceDefault,
            background: DesignTokens.backgroundPrimary,
            error: DesignTokens.error,
          ),
          textTheme: GoogleFonts.interTextTheme(
            ThemeData.dark().textTheme.copyWith(
              displayLarge: DesignTokens.displayLarge,
              displayMedium: DesignTokens.displayMedium,
              headlineLarge: DesignTokens.heading1,
              headlineMedium: DesignTokens.heading2,
              headlineSmall: DesignTokens.heading3,
              bodyLarge: DesignTokens.bodyLarge,
              bodyMedium: DesignTokens.bodyMedium,
              bodySmall: DesignTokens.bodySmall,
            ),
          ),
          useMaterial3: true,
        ),
        home: const AppInitializer(),
      ),
    );
  }
}

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkOnboardingStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: DesignTokens.backgroundPrimary,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(DesignTokens.primary),
              ),
            ),
          );
        }
        
        final hasSeenOnboarding = snapshot.data ?? false;
        return hasSeenOnboarding ? const MainScreen() : const OnboardingScreen();
      },
    );
  }

  Future<bool> _checkOnboardingStatus() async {
    // In a real app, check SharedPreferences
    // For now, always show onboarding first
    await Future.delayed(const Duration(milliseconds: 500));
    return false;
  }
}
