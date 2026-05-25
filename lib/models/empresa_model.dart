class EmpresaModel {
  final String nome;
  final String bannerUrl;
  final String descricao;
  final String campanha;
  final List<String> itens;
  final String endereco;
  final String horario;
  final String telefone;
  final double latitude;
  final double longitude;

  EmpresaModel({
    required this.nome,
    required this.bannerUrl,
    required this.descricao,
    required this.campanha,
    required this.itens,
    required this.endereco,
    required this.horario,
    required this.telefone,
    required this.latitude,
    required this.longitude,
  });
}