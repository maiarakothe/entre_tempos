import 'package:entre_tempos/ui/pages/splash/splash_screen.dart';
import 'package:flutter/material.dart';

import '../../../data/models/letter.dart';
import '../auth/login_page.dart';
import '../auth/signup_page.dart';
import '../letters/letter_page.dart';
import '../letters/new_letter_page.dart';
import '../letters/view_letter_page.dart';
import '../profile/profile_page.dart';
import '../../widgets/envelope_opening_animation.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String newLetter = '/new_letter';
  static const String viewLetter = '/view_letter';
  static const String profile = '/profile';
  static const String envelopeAnimation = '/envelope_animation';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _route(const SplashPage());

      case login:
        return _route(const LoginPage());

      case signup:
        return _route(const SignupPage());

      case home:
        return _route(const LetterPage());

      case profile:
        return _route(const ProfilePage());

      case newLetter:
        final String? args = settings.arguments as String?;
        return _route(NewLetterPage(parentId: args));

      case viewLetter:
        final ViewLetterArgs args = settings.arguments as ViewLetterArgs;
        return _route(ViewLetterPage(letter: args.letter));

      case envelopeAnimation:
        final EnvelopeArgs args = settings.arguments as EnvelopeArgs;
        return _route(
          EnvelopeOpeningAnimation(
            letterTitle: args.letterTitle,
            onOpen: args.onOpen,
          ),
        );

      default:
        return _route(
          Scaffold(
            body: Center(child: Text('Rota não encontrada: ${settings.name}')),
          ),
        );
    }
  }

  static PageRoute _route(Widget page) {
    return PageRouteBuilder<dynamic>(
      pageBuilder: (_, _, _) => page,
      transitionDuration: const Duration(milliseconds: 200),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (_, Animation<double> animation, _, Widget child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
    );
  }
}

class ViewLetterArgs {
  final Letter letter;

  ViewLetterArgs({required this.letter});
}

class EnvelopeArgs {
  final String letterTitle;
  final VoidCallback onOpen;

  EnvelopeArgs({required this.letterTitle, required this.onOpen});
}
