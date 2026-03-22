import 'package:flutter/material.dart';

import '../pages/routes/routes.dart';
import '../../core/default_colors.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Row(
        children: <Widget>[
          Image.asset(
            'assets/images/logo-sem-fundo.png',
            width: 150,
            height: 90,
          ),
        ],
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.person_outline),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'perfil',
                child: const Row(
                  children: <Widget>[
                    Icon(Icons.person, size: 18),
                    SizedBox(width: 8),
                    Text('Perfil'),
                  ],
                ),
                onTap: () {
                  Future<dynamic>.delayed(Duration.zero, () {
                    Navigator.pushNamed(context, AppRoutes.profile);
                  });
                },
              ),
              PopupMenuItem<String>(
                value: 'sair',
                child: const Row(
                  children: <Widget>[
                    Icon(Icons.logout, size: 18),
                    SizedBox(width: 8),
                    Text('Sair'),
                  ],
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
