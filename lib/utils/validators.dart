class Validators {
  static final RegExp emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe o email';
    }

    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe a senha';
    }

    if (value.length < 6) {
      return 'Mínimo de 6 caracteres';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirme a senha';
    }
    if (value != password) {
      return 'As senhas não conferem';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe seu nome';
    }
    if (value.trim().length < 3) {
      return 'Nome muito curto';
    }
    return null;
  }
}
