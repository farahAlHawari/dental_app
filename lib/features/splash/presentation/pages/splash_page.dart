import 'package:dental_app/core/navigation/app_bootstrap_page.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/features/splash/presentation/widgets/animated_splash_logo.dart';
import 'package:flutter/material.dart';

/// Brand splash — full logo first, then bootstrap (session / language / loading).
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const Duration displayDuration = Duration(milliseconds: 2500);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _goToBootstrap());
  }

  Future<void> _goToBootstrap() async {
    await Future.delayed(SplashPage.displayDuration);
    await SharedPrefs.setHasSeenSplash(true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AppBootstrapPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      body: const Center(
        child: AnimatedSplashLogo(),
      ),
    );
  }
}
