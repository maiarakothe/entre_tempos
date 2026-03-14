import 'package:entre_tempos/core/utils.dart';
import 'package:flutter/material.dart';

import '../../core/Colors.dart';
import '../widgets/app_button.dart';
import '../widgets/page_card_layout.dart';
import 'letter_page.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Widget header() {
    return Column(
      children: <Widget>[
        Text(
          'entreTempos',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
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
              filled: true,
              fillColor: Colors.grey.shade100,
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: DefaultBorders.container,
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 14),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              filled: true,
              fillColor: Colors.grey.shade100,
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: DefaultBorders.container,
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 14),
          TextFormField(
            controller: passwordController,
            obscureText: obscurePassword,
            decoration: InputDecoration(
              labelText: 'Senha',
              filled: true,
              fillColor: Colors.grey.shade100,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: DefaultBorders.container,
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 14),
          TextFormField(
            controller: confirmPasswordController,
            obscureText: obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: 'Confirmar senha',
              prefixIcon: const Icon((Icons.lock_reset_outlined)),
              filled: true,
              fillColor: Colors.grey.shade100,
              suffixIcon: IconButton(
                icon: Icon(
                  obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    obscureConfirmPassword = !obscureConfirmPassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: DefaultBorders.container,
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 24),
          AppButton(
            text: 'Entrar',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<dynamic>(builder: (_) => LetterPage()),
              );
            },
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
              TextButton(
                child: Text('Entrar'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<dynamic>(builder: (_) => LoginPage()),
                  );
                },
              ),
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
