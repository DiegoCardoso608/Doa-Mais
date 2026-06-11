import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InteressadoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> registrarInteresse({
    required String campanhaId,
    required String campanhaTitulo,
    required String empresaId,
  }) async {
    try {
      final usuario = _auth.currentUser;

      if (usuario == null) {
        return 'Usuário não autenticado';
      }

      final usuarioDoc = await _firestore
          .collection('usuarios')
          .doc(usuario.uid)
          .get();

      final dadosUsuario = usuarioDoc.data();

      // Busca só por usuarioId para evitar índice composto,
      // depois filtra por campanhaId no cliente
      final existentes = await _firestore
          .collection('interessados')
          .where('usuarioId', isEqualTo: usuario.uid)
          .get();

      final jaRegistrado = existentes.docs.any(
        (doc) => (doc.data())['campanhaId'] == campanhaId,
      );

      if (jaRegistrado) {
        return 'Você já demonstrou interesse nesta campanha';
      }

      await _firestore.collection('interessados').add({
        'campanhaId': campanhaId,
        'campanhaTitulo': campanhaTitulo,
        'empresaId': empresaId,
        'usuarioId': usuario.uid,
        'usuarioNome': '${dadosUsuario?['nome'] ?? ''} ${dadosUsuario?['sobrenome'] ?? ''}'.trim(),
        'usuarioEmail': usuario.email ?? '',
        'status': 'pendente',
        'dataCriacao': Timestamp.now(),
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
