import 'package:code/features/home/home_screen.dart';
import 'package:code/features/upload/blog_upload_screen.dart';
import 'package:code/providers/app_providers.dart';
import 'package:code/providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:code/utils/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'features/auth/login_screen.dart';
import 'features/home/blog_viewer.dart';
import 'features/saved_blogs/saved_blogs_screen.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
 
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var darkMode = ref.watch(darkModeProvider);
    return MaterialApp(
      theme:
          ThemeData(useMaterial3: true, colorScheme: const ColorScheme.light()),
      darkTheme:
          ThemeData(useMaterial3: true, colorScheme: const ColorScheme.dark()),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,

      initialRoute: '/',
      // initialRoute: _googleSignIn.currentUser == null ? '/' : '/homeScreen',
      routes: {
        '/': (context) => const SplashScreen(),
        '/loginScreen': (context) => LoginScreen(),
        '/homeScreen': (context) => const HomeScreen(),
        '/blogUploadScreen': (context) => const BlogUploadScreen(),
        '/savedBlogsScreen': (context) => const SavedBlogsScreen(),
        '/blogViewerScreen': (context) =>  BlogViewerScreen(),
      },
    );
  }
}
