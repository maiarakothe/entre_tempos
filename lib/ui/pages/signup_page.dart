import 'package:entre_tempos/core/utils.dart';
import 'package:flutter/material.dart';

import '../../core/Colors.dart';
import '../widgets/page_card_layout.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Widget header() {
    return Column(
      children: <Widget>[
        Text(
          'entreTempos',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          'Escreva hoje. Leia amanhã.',
          style: TextStyle(fontSize: 14, color: DefaultColors.textSecondary),
        ),
      ],
    );
  }

  Widget content() {
    return Form(
      child: Column(
        children: <Widget>[
          header(),
          SizedBox(height: 20),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Nome',
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: DefaultBorders.container,
              ),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: DefaultBorders.container,
              ),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Senha',
              prefixIcon: const Icon(Icons.lock_outline),
              border: OutlineInputBorder(
                borderRadius: DefaultBorders.container,
              ),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Confirmar senha',
              prefixIcon: const Icon(Icons.lock_outline),
              border: OutlineInputBorder(
                borderRadius: DefaultBorders.container,
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: DefaultBorders.button,
                ),
                padding: EdgeInsets.zero,
              ),
              child: Ink(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[Color(0xFFFF6FB1), Color(0xFF6A8CFF)],
                  ),
                  borderRadius: DefaultBorders.button,
                ),
                child: const Center(
                  child: Text(
                    "Entrar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(height: 5),
          Row(
            children: <Widget>[
              Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('ou'),
              ),
              Expanded(child: Divider()),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Já tem conta?'),
              TextButton(child: Text('Entrar'), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: PageCardLayout(child: content()));
  }
}
