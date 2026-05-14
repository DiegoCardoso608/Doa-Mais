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
        'rua': rua,
        'bairro': bairro,
        'numero': numero,
        'dataNascimento': dataNascimento,
        'tipo': 'pf',
        'criadoEm': Timestamp.now(),
      });

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

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }
}