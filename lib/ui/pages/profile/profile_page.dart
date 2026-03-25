import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entre_tempos/ui/widgets/app_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/default_colors.dart';
import '../../../core/utils.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/page_card_layout.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        return;
      }
      setState(() {
        nameController.text = doc.data()?['name'] ?? '';
        emailController.text = user.email ?? '';
      });
    } catch (e) {
      print('Erro ao carregar usuário: $e');
    }
  }

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
          controller: nameController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Nome completo',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(borderRadius: DefaultBorders.container),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: emailController,
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
          child: AppButton(text: 'Editar Perfil', onPressed: () {}),
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
