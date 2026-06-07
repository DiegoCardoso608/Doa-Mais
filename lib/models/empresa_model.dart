class CampanhaModel {
  final String id;
  final String empresaId;
  final String empresaNome;
  final String titulo;
  final String descricao;
  final String categoria;
  final List<String> itensNecessarios;
  final String enderecoColeta;
  final String telefoneContato;
  final String imagemUrl;
  final String status;
  final int totalDoacoes;

  CampanhaModel({
    required this.id,
    required this.empresaId,
    required this.empresaNome,
    required this.titulo,
    required this.descricao,
    required this.categoria,
    required this.itensNecessarios,
    required this.enderecoColeta,
    required this.telefoneContato,
    required this.imagemUrl,
    required this.status,
    required this.totalDoacoes,
  });
}