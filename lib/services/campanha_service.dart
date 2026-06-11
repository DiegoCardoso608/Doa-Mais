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
    double? latitude,
    double? longitude,
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
      'latitude': latitude,
      'longitude': longitude,
      'status': 'ativa',
      'totalDoacoes': 0,
      'dataCriacao': Timestamp.now(),
    });
  }

  Future<void> editarCampanha({
    required String campanhaId,
    required String titulo,
    required String descricao,
    required String categoria,
    required String imagem,
    required List itensNecessarios,
    required String telefoneContato,
  }) async {
    await _firestore
        .collection('campanhas')
        .doc(campanhaId)
        .update({
      'titulo': titulo,
      'descricao': descricao,
      'categoria': categoria,
      'imagem': imagem,
      'itensNecessarios': itensNecessarios,
      'telefoneContato': telefoneContato,
    });
  }

  Future<void> encerrarCampanha(
    String campanhaId,
  ) async {
    await _firestore
        .collection('campanhas')
        .doc(campanhaId)
        .update({
      'status': 'encerrada',
    });
  }
}