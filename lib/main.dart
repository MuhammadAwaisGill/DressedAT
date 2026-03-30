import 'package:dressedat/features/auth/presentation/screens/login_screen.dart';
import 'package:dressedat/features/auth/presentation/screens/signup_screen.dart';
import 'package:dressedat/features/outfit/data/outfit_model.dart';
import 'package:dressedat/features/outfit/presentation/screens/outfit_detail_screen.dart';
import 'package:dressedat/shared/screens/about_screen.dart';
import 'package:dressedat/shared/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/data/auth_repository.dart';
import 'shared/screens/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dressedat/features/outfit/presentation/screens/add_outfit_screen.dart';
import 'package:dressedat/features/outfit/presentation/screens/outfit_history_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null || supabaseKey == null) {
    throw Exception("Missing Supabase env variables");
  }

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DressedAT',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/add-outfit': (context) => const AddOutfitScreen(),
        '/outfit-history': (context) => const OutfitHistoryScreen(),
        '/about': (context) => const AboutScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/outfit-detail') {
          final outfit = settings.arguments as Outfit;
          return MaterialPageRoute(
            builder: (context) => OutfitDetailScreen(outfit: outfit),
          );
        }
        return null;
      },
    );
  }
}