import 'package:entre_tempos/ui/widgets/page_card_layout.dart';
import 'package:entre_tempos/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../data/services/auth_service.dart';
import '../../../utils/auth_error_handler.dart';
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
  FocusNode emailFocus = FocusNode();

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _recoverFormKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future<Null>.delayed(Duration.zero, () {
      emailFocus.requestFocus();
    });
  }

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

  void showRecoverPasswordDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Recuperar senha'),
              IconButton(
                onPressed: () => Navigator.pop(dialogContext),
                hoverColor: Colors.transparent,
                icon: CircleAvatar(
                  backgroundColor: Colors.grey.shade100,
                  radius: 22,
                  child: Icon(Icons.close, size: 20, color: DefaultColors.text),
                ),
              ),
            ],
          ),
          backgroundColor: DefaultColors.cardLight,
          shape: RoundedRectangleBorder(borderRadius: DefaultBorders.card),
          content: Form(
            key: _recoverFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Digite seu e-mail para receber as instruções de recuperação',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  validator: Validators.validateEmail,
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
          ),
          actions: <Widget>[
            AppButton(
              text: 'Enviar',
              fullWidth: false,
              onPressed: () async {
                if (!_recoverFormKey.currentState!.validate()) {
                  return;
                }
                final String email = emailController.text.trim();
                try {
                  await AuthService().resetPassword(email);
                  Navigator.pop(context);
                  showSuccess(
                    dialogContext,
                    'Instruções de recuperação enviadas!',
                  );
                } catch (e) {
                  showError(dialogContext, 'Erro ao enviar recuperação');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void submitForm() async {
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }
    final String email = emailController.text.trim();
    final String password = passwordController.text;
    try {
      final User? user = await AuthService().login(
        email: email,
        password: password,
      );
      if (user != null) {
        showSuccess(context, 'Login realizado com sucesso!');
        await Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } catch (e) {
      final String message = getAuthErrorMessage(e);
      showError(context, message);
    }
  }

  Widget content() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: <Widget>[
          header(),
          SizedBox(height: 20),
          TextFormField(
            controller: emailController,
            validator: Validators.validateEmail,
            textInputAction: TextInputAction.next,
            focusNode: emailFocus,
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
            textInputAction: TextInputAction.send,
            onFieldSubmitted: (_) => submitForm(),
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
          AppButton(text: 'Entrar', onPressed: submitForm),
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
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: PageCardLayout(child: content()));
  }
}
