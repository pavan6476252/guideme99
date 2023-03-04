import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:code/pages/blogs/blogs_page.dart';
import 'package:code/pages/ecet_docs/ecet_docs_page.dart';
import 'package:code/pages/home/home_page.dart';
import 'package:code/pages/viit_docs/vii_docs_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(
      child: MyApp(
    savedThemeMode: savedThemeMode,
  )));
}

class MyApp extends StatelessWidget {
  AdaptiveThemeMode? savedThemeMode;
  MyApp({required this.savedThemeMode, super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        theme: theme,
    darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            // case '/':
            //   return MaterialPageRoute(builder: (context) => const SplashScreen());
            // case '/':
            //   return MaterialPageRoute(builder: (context) => HomePage());
            // // case '/homepage':
            // //   return MaterialPageRoute(builder: (context) => HomePage());
            // case '/signupscreen':
            //   return MaterialPageRoute(builder: (context) =>  SignUpPage());
            // case '/loginpage':
            //   return MaterialPageRoute(builder: (context) =>  LoginPage());
            // case '/ecetcsepage':
            //   return MaterialPageRoute(builder: (context) => const EcetCsePage());

            // case '/settingspage':
            //   return MaterialPageRoute(builder: (context) => const SettingPage());

            case '/':
              return MaterialPageRoute(
                builder: (context) => ViitDocsPage(),
              );
            // case '/blogspage':
            //   return MaterialPageRoute(
            //     builder: (context) => const BlogsPage(),
            //   );
            // case '/viitdocspage':
            //   return MaterialPageRoute(
            //     builder: (context) =>  ViitDocsPage(),
            //   );
            // case '/ecetdocspage':
            //   return MaterialPageRoute(
            //     builder: (context) => const EcetDocsPage(),
            //   );

            default:
              return MaterialPageRoute(
                  builder: (context) => const Scaffold(
                        body: Center(
                          child: Text("page not found!!"),
                        ),
                      ));
          }
        },
      ),
    );
  }
}
