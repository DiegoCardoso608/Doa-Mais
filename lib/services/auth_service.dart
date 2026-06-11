import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CADASTRO PF
  Future<String?> cadastrarPF({
    required String nome,
    required String sobrenome,
    required String email,
    required String senha,
    required String rua,
    required String bairro,
    required String numero,
    required String dataNascimento,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      await _firestore
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .set({
        'nome': nome,
        'sobrenome': sobrenome,
        'email': email,
        'telefone': '',
        'rua': rua,
        'bairro': bairro,
        'numero': numero,
        'dataNascimento': dataNascimento,
        'fotoPerfil': '',
        'emailVerificado': false,
        'tipo': 'pf',
        'criadoEm': Timestamp.now(),
      });

      // Enviar email de verificação
      await userCredential.user!.sendEmailVerification();

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // LOGIN PF
  Future<String?> loginPF({
    required String email,
    required String senha,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // Recarregar dados do usuário
      await _auth.currentUser?.reload();

      final user = _auth.currentUser;

      if (user != null && !user.emailVerified) {
        await _auth.signOut();
        return 'Confirme seu e-mail antes de entrar.';
      }

      // Atualizar Firestore se email foi verificado
      if (user != null && user.emailVerified) {
        await _firestore
            .collection('usuarios')
            .doc(user.uid)
            .update({
          'emailVerificado': true,
        });
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // REENVIAR EMAIL DE VERIFICAÇÃO
  Future<String?> reenviarEmailVerificacao() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}