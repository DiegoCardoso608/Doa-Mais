import 'package:cloud_firestore/cloud_firestore.dart';

class CampanhaService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> criarCampanha({
    required String empresaId,
    required String empresaNome,
    required String titulo,
    required String descricao,
    required String categoria,
    required String imagem,
    required List<String> itensNecessarios,
    required String enderecoColeta,
    required String telefoneContato,
  }) async {
    await _firestore.collection('campanhas').add({
      'empresaId': empresaId,
      'empresaNome': empresaNome,
      'titulo': titulo,
      'descricao': descricao,
      'categoria': categoria,
      'imagem': imagem,
      'itensNecessarios': itensNecessarios,
      'enderecoColeta': enderecoColeta,
      'telefoneContato': telefoneContato,
      'status': 'ativa',
      'totalDoacoes': 0,
      'dataCriacao': Timestamp.now(),
    });
  }
}