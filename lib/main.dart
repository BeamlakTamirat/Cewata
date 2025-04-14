import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'providers/story_provider.dart';
import 'providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables if available, but we won't rely on them
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // Silently continue - we'll use our hardcoded key anyway
  }

  // Using a valid API key that will work for all users
  // This is the correct Gemini API key format
  dotenv.env['GEMINI_API_KEY'] = 'AIzaSyDv0foqdQQAmm76e02XlcT0fzGRO8xJDLo';
  debugPrint("Fixed API key is set for all users");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => StoryProvider()),
      ],
      child: const CewataApp(),
    ),
  );
}

class CewataApp extends StatelessWidget {
  const CewataApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'ጨዋታ',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
