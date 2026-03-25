import 'package:entre_tempos/ui/pages/auth/auth_gate.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
    Future<dynamic>.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<dynamic>(builder: (_) => const AuthGate()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: controller,
          child: Center(
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1.0).animate(controller),
              child: Image.asset(
                'assets/images/icone-sem-fundo.png',
                width: 260,
                height: 260,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
