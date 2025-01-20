import 'package:drawing_app/draw/draw.dart';
import 'package:drawing_app/splash_screen/view/view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const DrawingApp());
}

class DrawingApp extends StatelessWidget {
  const DrawingApp({super.key});

  @override
  Widget build(BuildContext context) {
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
        cardTheme: const CardTheme(
          color: Color.fromARGB(255, 136, 132, 132),
        ),
      ),
    );
  }
}
