import 'package:entre_tempos/ui/widgets/page_card_layout.dart';
import 'package:flutter/material.dart';

import '../routes/routes.dart';
import '../../../core/default_colors.dart';
import '../../../core/utils.dart';
import '../../widgets/app_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscurePassword = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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

  void showRecoverPasswordDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Recuperar senha'),
          backgroundColor: DefaultColors.cardLight,
          shape: RoundedRectangleBorder(borderRadius: DefaultBorders.card),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Digite seu e-mail para receber as instruções de recuperação',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: DefaultBorders.container,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            AppButton(
              text: 'Enviar',
              fullWidth: false,
              onPressed: () {
                final String email = emailController.text;
                if (email.isNotEmpty) {
                  print('Enviar recuperação para: $email');

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Instruções enviadas para seu e-mail'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget content() {
    return Form(
      child: Column(
        children: <Widget>[
          header(),
          SizedBox(height: 20),
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
          SizedBox(height: 24),
          AppButton(
            text: 'Entrar',
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            },
          ),
          SizedBox(height: 10),
          TextButton(
            child: Text('Esqueci minha senha'),
            onPressed: () {
              showRecoverPasswordDialog(context);
            },
          ),
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
              Text('Não tem conta?'),
              TextButton(
                child: Text('Criar conta'),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.signup);
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
