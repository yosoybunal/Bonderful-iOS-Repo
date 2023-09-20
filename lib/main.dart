import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herkese_sor/models/purchase_api.dart';
import 'package:herkese_sor/screens/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:herkese_sor/screens/splash_screen.dart';
import 'package:herkese_sor/screens/tabs_screen.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

// final _configuration =
//     PurchasesConfiguration('appl_toUfVdcFmkpqtVfByEXhChOLlmL');

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 255, 225, 90),
);

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Purchases.configure(_configuration);
  await PurchaseApi.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.dark);
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.dark);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (BuildContext context, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bonderful',
          theme: ThemeData.light().copyWith(
            useMaterial3: true,
            colorScheme: kColorScheme,
            textTheme: ThemeData().textTheme.copyWith(
                  titleLarge: GoogleFonts.alef(fontSize: 23).copyWith(
                    color: kColorScheme.onBackground,
                  ),
                  titleMedium: GoogleFonts.alef(fontSize: 21).copyWith(
                    color: kColorScheme.onBackground,
                  ),
                  titleSmall: GoogleFonts.alef(fontSize: 17).copyWith(
                    color: kColorScheme.secondary,
                  ),
                  bodyMedium: GoogleFonts.alef(fontSize: 18).copyWith(
                    color: kColorScheme.secondary,
                  ),
                  bodyLarge: GoogleFonts.alef(fontSize: 18),
                ),
            drawerTheme: ThemeData().drawerTheme.copyWith(
                  backgroundColor: kColorScheme.surface,
                ),
            bottomSheetTheme: const BottomSheetThemeData(
              modalBackgroundColor: Color.fromARGB(249, 235, 232, 229),
            ),
            appBarTheme: ThemeData().appBarTheme.copyWith(
                  backgroundColor: kColorScheme.secondary,
                  foregroundColor: kColorScheme.background,
                ),
            bottomNavigationBarTheme: ThemeData()
                .bottomNavigationBarTheme
                .copyWith(selectedItemColor: kColorScheme.secondary),
          ),
          darkTheme: ThemeData.dark().copyWith(
            useMaterial3: true,
            colorScheme: kColorScheme,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color.fromARGB(255, 54, 51, 47),
            textTheme: ThemeData().textTheme.copyWith(
                  titleLarge: GoogleFonts.alef(fontSize: 23).copyWith(
                    color: kColorScheme.background,
                  ),
                  titleMedium: GoogleFonts.alef(fontSize: 21).copyWith(
                    color: kColorScheme.background,
                  ),
                  titleSmall: GoogleFonts.alef(fontSize: 17).copyWith(
                    color: kColorScheme.inversePrimary,
                  ),
                  bodyMedium: GoogleFonts.alef(fontSize: 18).copyWith(
                    color: kColorScheme.secondary,
                  ),
                  bodyLarge: GoogleFonts.alef(fontSize: 18),
                ),
            drawerTheme: ThemeData().drawerTheme.copyWith(
                  backgroundColor: kColorScheme.inverseSurface,
                ),
            bottomSheetTheme: const BottomSheetThemeData(
              modalBackgroundColor: Color.fromARGB(255, 75, 73, 71),
            ),
            appBarTheme: ThemeData().appBarTheme.copyWith(
                backgroundColor: kColorScheme.secondary,
                foregroundColor: kColorScheme.background),
            bottomNavigationBarTheme: ThemeData()
                .bottomNavigationBarTheme
                .copyWith(selectedItemColor: kColorScheme.inversePrimary),
          ),
          themeMode: currentMode,
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }
              if (snapshot.hasData) {
                return const TabsScreen();
              }
              return const AuthScreen();
            },
          ),
        );
      },
    );
  }
}
