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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Force portrait mode and set status bar
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
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
          scaffoldBackgroundColor: Colors.black,
          textTheme: GoogleFonts.interTextTheme(
            ThemeData.dark().textTheme,
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
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
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
