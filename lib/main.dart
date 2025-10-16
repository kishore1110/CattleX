import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase. On web, Firebase requires explicit FirebaseOptions.
  // To avoid crashes in web builds without configured options, we attempt to
  // read options from --dart-define values. If not provided, we skip web
  // initialization so the app can boot (Firestore features will be inactive
  // until proper configuration is added).
  if (kIsWeb) {
    final apiKey = const String.fromEnvironment('FIREBASE_API_KEY');
    final appId = const String.fromEnvironment('FIREBASE_APP_ID');
    final messagingSenderId = const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
    final projectId = const String.fromEnvironment('FIREBASE_PROJECT_ID');
    final authDomain = const String.fromEnvironment('FIREBASE_AUTH_DOMAIN');
    final storageBucket = const String.fromEnvironment('FIREBASE_STORAGE_BUCKET');
    final measurementId = const String.fromEnvironment('FIREBASE_MEASUREMENT_ID');

    final hasRequiredWebOptions = apiKey.isNotEmpty &&
        appId.isNotEmpty &&
        messagingSenderId.isNotEmpty &&
        projectId.isNotEmpty;

    if (hasRequiredWebOptions) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: apiKey,
          appId: appId,
          messagingSenderId: messagingSenderId,
          projectId: projectId,
          authDomain: authDomain.isNotEmpty ? authDomain : null,
          storageBucket: storageBucket.isNotEmpty ? storageBucket : null,
          measurementId: measurementId.isNotEmpty ? measurementId : null,
        ),
      );
    } else {
      debugPrint('Firebase web initialization skipped: missing --dart-define options.');
    }
  } else {
    await Firebase.initializeApp();
  }

  runApp(const CattleXApp());
}
// Professional Color Palette for Government App
class AppColors {
  // Primary Green Shades
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color primaryGreenLight = Color(0xFF4CAF50);
  static const Color primaryGreenDark = Color(0xFF1B5E20);
  
  // Secondary Green Shades
  static const Color secondaryGreen = Color(0xFF66BB6A);
  static const Color secondaryGreenLight = Color(0xFF81C784);
  static const Color accentGreen = Color(0xFF388E3C);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Shadow and Border
  static const Color shadow = Color(0x1A000000);
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);
}

class CattleXApp extends StatelessWidget {
  const CattleXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CattleX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
          primary: AppColors.primaryGreen,
          secondary: AppColors.secondaryGreen,
          surface: AppColors.backgroundWhite,
          error: AppColors.error,
        ),
        
        // App Bar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        
        // Card Theme
        cardTheme: CardThemeData(
          color: AppColors.cardBackground,
          elevation: 2,
          shadowColor: AppColors.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        
        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: Colors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        // Outlined Button Theme
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryGreen,
            side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.backgroundWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        
        // Bottom Navigation Bar Theme
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.backgroundWhite,
          selectedItemColor: AppColors.primaryGreen,
          unselectedItemColor: AppColors.textLight,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
        
        // Text Theme
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: AppColors.textPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: AppColors.textSecondary,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: AppColors.textLight,
          ),
        ),
        
        // Scaffold Background
        scaffoldBackgroundColor: AppColors.backgroundLight,
      ),
      home: const SplashScreen(),
    );
  }
}
