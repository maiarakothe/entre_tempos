import 'package:entre_tempos/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../data/services/auth_service.dart';
import '../../../utils/auth_error_handler.dart';
import '../routes/routes.dart';
import '../../../core/utils.dart';
import '../../widgets/app_button.dart';
import '../../widgets/page_card_layout.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Widget header() {
    return Center(
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/images/icone-sem-fundo.png',
            fit: BoxFit.contain,
            width: 300,
            height: 120,
          ),
        ],
      ),
    );
  }

  Widget content() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          header(),
          SizedBox(height: 20),
          TextFormField(
            controller: nameController,
            validator: Validators.validateName,
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
            validator: Validators.validateEmail,
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
            validator: Validators.validatePassword,
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
            validator: (String? value) {
              return Validators.validateConfirmPassword(
                value,
                passwordController.text,
              );
            },
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
            text: 'Cadastrar',
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }

              final String name = nameController.text.trim();
              final String email = emailController.text.trim();
              final String password = passwordController.text;

              try {
                final User? user = await AuthService().register(
                  name: name,
                  email: email,
                  password: password,
                );

                if (user != null) {
                  showSuccess(context, 'Conta criada com sucesso!');
                  await Navigator.pushReplacementNamed(context, AppRoutes.home);
                }
              } catch (e) {
                final String message = getAuthErrorMessage(e);
                showError(context, message);
              }
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
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: PageCardLayout(child: content()));
  }
}
