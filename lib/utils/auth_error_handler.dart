import 'package:firebase_auth/firebase_auth.dart';

String getAuthErrorMessage(Object e) {
  if (e is FirebaseAuthException) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Esse email já está em uso';
      case 'invalid-email':
        return 'Email inválido';
      case 'user-not-found':
        return 'Usuário não encontrado';
      case 'wrong-password':
        return 'Senha incorreta';
      case 'invalid-credential':
        return 'Email ou senha inválidos';
      case 'network-request-failed':
        return 'Sem conexão com a internet';
      default:
        print('CÓDIGO NÃO TRATADO: ${e.code}');
        return 'Erro de autenticação';
    }
  }

  return 'Ocorreu um erro inesperado';
}
