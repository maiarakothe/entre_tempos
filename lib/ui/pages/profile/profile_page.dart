import 'package:entre_tempos/data/models/user.dart';
import 'package:entre_tempos/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';

import '../../../core/default_colors.dart';
import '../../../core/utils.dart';
import '../../../data/services/user_service.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/page_card_layout.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  bool isLoading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final AppUser user = await UserService().getUserData();
      nameController.text = user.name;
      emailController.text = user.email;
    } catch (e) {
      showError(context, 'Erro ao carregar usuário');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await UserService().updateUserName(nameController.text);
      setState(() {
        isEditing = false;
      });
      showSuccess(context, 'Nome atualizado com sucesso!');
    } catch (e) {
      showError(context, 'Erro ao atualizar nome');
    } finally {
      setState(() {
        isLoading = false;
      });
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
              gradient: DefaultColors.backgroundGradient,
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
          readOnly: !isEditing,
          enabled: isEditing,
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
          enabled: false,
          decoration: InputDecoration(
            labelText: 'Email',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            alignLabelWithHint: true,
            border: OutlineInputBorder(borderRadius: DefaultBorders.container),
          ),
        ),
        Text(
          'O email não pode ser alterado',
          style: TextStyle(fontSize: 12, color: DefaultColors.textSecondary),
        ),
        const SizedBox(height: 20),
        buttons(),
      ],
    );
  }

  Widget buttons() {
    return Column(
      children: <Widget>[
        if (isEditing) ...<Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              AppButton(
                text: 'Cancelar',
                fullWidth: false,
                backgroundColor: DefaultColors.error,
                onPressed: () async {
                  setState(() {
                    isEditing = false;
                  });

                  await loadUserData();
                },
              ),
              const SizedBox(width: 10),
              AppButton(
                text: isLoading ? 'Salvando...' : 'Salvar',
                fullWidth: false,
                disabled: isLoading,
                onPressed: saveUserData,
              ),
            ],
          ),
        ],
        if (!isEditing)
          AppButton(
            text: 'Editar Nome',
            onPressed: () {
              setState(() {
                isEditing = true;
              });
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBarWidget(),
      body: PageCardLayout(child: content()),
    );
  }
}
