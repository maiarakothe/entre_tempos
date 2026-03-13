import 'package:flutter/material.dart';

import '../../core/Colors.dart';
import '../../core/utils.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/page_card_layout.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget content() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: Text(
            'Meu perfil',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(height: 40),
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: DefaultColors.colorTest,
            ),
            child: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.person,
                size: 45,
                color: DefaultColors.cardLight,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Nome completo',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(borderRadius: DefaultBorders.container),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Email',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            alignLabelWithHint: true,
            border: OutlineInputBorder(borderRadius: DefaultBorders.container),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            gradient: DefaultColors.colorTest,
            borderRadius: DefaultBorders.button,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: DefaultColors.primary.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            label: Text(
              'Editar Perfil',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            iconAlignment: IconAlignment.end,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: DefaultBorders.button,
              ),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(),
      body: PageCardLayout(child: content()),
    );
  }
}
