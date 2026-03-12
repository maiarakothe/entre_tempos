import 'package:flutter/material.dart';

import '../../core/Colors.dart';
import '../pages/profile_page.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: DefaultColors.colorTest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.mail,
              size: 18,
              color: DefaultColors.cardLight,
            ),
          ),
          const SizedBox(width: 8),
          const Text("EntreTempos"),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (_) => const ProfilePage(),
                      ),
                    );
                  });
                },
              ),
              const PopupMenuItem<String>(
                value: 'sair',
                child: Row(
                  children: <Widget>[
                    Icon(Icons.logout, size: 18),
                    SizedBox(width: 8),
                    Text('Sair'),
                  ],
                ),
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
