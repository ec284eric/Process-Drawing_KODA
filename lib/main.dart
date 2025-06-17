import 'package:drawing_app/draw/draw.dart';
import 'package:drawing_app/splash_screen/view/view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:drawing_app/l10n/app_localizations.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const DrawingApp());
}

class DrawingApp extends StatefulWidget {
  const DrawingApp({super.key});

  @override
  State<DrawingApp> createState() => _DrawingAppState();
}

class _DrawingAppState extends State<DrawingApp> {
  final GoRouter router = GoRouter(
    initialLocation: SplashScreenPage.route,
    routes: <RouteBase>[
      GoRoute(
        path: DrawPage.route,
        builder: (BuildContext context, GoRouterState state) {
          return const DrawPage();
        },
      ),
      GoRoute(
        path: SplashScreenPage.route,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreenPage();
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
      ],
      theme: ThemeData(
        filledButtonTheme: const FilledButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Color.fromARGB(255, 136, 132, 132),
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 136, 132, 132),
        ),
        cardTheme: const CardThemeData(
          color: Color.fromARGB(255, 136, 132, 132),
        ),
      ),
    );
  }
}
