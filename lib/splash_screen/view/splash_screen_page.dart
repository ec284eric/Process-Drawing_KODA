import 'package:drawing_app/splash_screen/view/view.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatelessWidget {
  static const route = '/splash-screen';

  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashScreenBody(),
    );
  }
}
