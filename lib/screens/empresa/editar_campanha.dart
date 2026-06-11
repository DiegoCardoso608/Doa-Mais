import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/campanha_service.dart';
import '../../services/cloudinary_service.dart';
import '../../utils/telefone_formatter.dart';

class EditarCampanha extends StatefulWidget {
  final String campanhaId;
  final Map<String, dynamic> campanha;

  const EditarCampanha({
    super.key,
    required this.campanhaId,
    required this.campanha,
  });

  @override
  State<EditarCampanha> createState() =>
      _EditarCampanhaState();
}

class _EditarCampanhaState extends State<EditarCampanha> {
  final tituloController = TextEditingController();
  final descricaoController = TextEditingController();
  final telefoneController = TextEditingController();
  final itemController = TextEditingController();

  List<String> itensNecessarios = [];

  String categoriaSelecionada = 'Roupa';

  bool carregando = false;

  final CampanhaService _campanhaService =
      CampanhaService();
  final CloudinaryService _cloudinaryService =
      CloudinaryService();

  String imagemUrl = '';

  @override
  void initState() {
    super.initState();

    tituloController.text =
        widget.campanha['titulo'] ?? '';

    descricaoController.text =
        widget.campanha['descricao'] ?? '';

    telefoneController.text =
        widget.campanha['telefoneContato'] ?? '';

    categoriaSelecionada =
        widget.campanha['categoria'] ?? 'Roupa';

    imagemUrl =
        widget.campanha['imagem'] ?? '';

    itensNecessarios =
        List<String>.from(
          widget.campanha[
              'itensNecessarios'] ??
          [],
        );
  }

  void adicionarItem() {
    final item = itemController.text.trim();

    if (item.isEmpty) return;

    setState(() {
      itensNecessarios.add(item);
    });

    itemController.clear();
  }

  void removerItem(int index) {
    setState(() {
      itensNecessarios.removeAt(index);
    });
  }

  Future selecionarImagem() async {
    try {
      final url =
          await _cloudinaryService.uploadImagem();

      if (url == null) return;

      setState(() {
        imagemUrl = url;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Imagem enviada com sucesso!',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao enviar imagem: $e',
          ),
        ),
      );
    }
  }

  Future<void> salvarAlteracoes() async {
    if (tituloController.text.trim().isEmpty ||
        descricaoController.text.trim().isEmpty ||
        telefoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos.'),
        ),
      );
      return;
    }

    try {
      setState(() {
        carregando = true;
      });

      await _campanhaService.editarCampanha(
        campanhaId: widget.campanhaId,
        titulo: tituloController.text.trim(),
        descricao:
            descricaoController.text.trim(),
        categoria: categoriaSelecionada,
        imagem: imagemUrl,
        itensNecessarios: itensNecessarios,
        telefoneContato:
            telefoneController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Campanha atualizada!',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
        ),
      );
    }

    setState(() {
      carregando = false;
    });
  }

  @override
  void dispose() {
    tituloController.dispose();
    descricaoController.dispose();
    telefoneController.dispose();
    itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEA),
      appBar: AppBar(
        title: const Text('Editar Campanha'),
        backgroundColor: const Color(0xFFAEC6CF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'Título da Campanha',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: tituloController,
              decoration: InputDecoration(
                hintText:
                    'Ex: Campanha do Agasalho',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Descrição',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: descricaoController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    'Descreva sua campanha',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Categoria',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: DropdownButton<String>(
                value: categoriaSelecionada,
                isExpanded: true,
                underline: Container(),
                items: const [
                  DropdownMenuItem(
                    value: 'Roupa',
                    child: Text('Roupa'),
                  ),
                  DropdownMenuItem(
                    value: 'Comida',
                    child: Text('Comida'),
                  ),
                  DropdownMenuItem(
                    value: 'Brinquedos',
                    child: Text('Brinquedos'),
                  ),
                  DropdownMenuItem(
                    value: 'Móveis',
                    child: Text('Móveis'),
                  ),
                  DropdownMenuItem(
                    value: 'Material Escolar',
                    child:
                        Text('Material Escolar'),
                  ),
                  DropdownMenuItem(
                    value: 'Outros',
                    child: Text('Outros'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      categoriaSelecionada =
                          value;
                    });
                  }
                },
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Itens Necessários',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: itemController,
                    decoration: InputDecoration(
                      hintText: 'Ex: Casaco',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: adicionarItem,
                  child: const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              itemCount:
                  itensNecessarios.length,
              itemBuilder:
                  (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.check_circle,
                    ),
                    title: Text(
                      itensNecessarios[index],
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                      ),
                      onPressed: () {
                        removerItem(index);
                      },
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Imagem da Campanha',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            if (imagemUrl.isNotEmpty)
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(12),
                child: Image.network(
                  imagemUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: selecionarImagem,
                icon: const Icon(Icons.image),
                label: const Text(
                  'Selecionar Imagem',
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Telefone para contato',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: telefoneController,
              keyboardType:
                  TextInputType.phone,
              inputFormatters: [
                TelefoneFormatter(),
              ],
              decoration: InputDecoration(
                hintText:
                    '(91) 99999-9999',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),
                onPressed:
                    carregando
                        ? null
                        : salvarAlteracoes,
                child:
                    carregando
                        ? const CircularProgressIndicator(
                            color:
                                Colors.white,
                          )
                        : const Text(
                            'Salvar Alterações',
                            style: TextStyle(
                              color:
                                  Colors.white,
                              fontSize: 18,
                            ),
                          ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                onPressed: () async {
                  final confirmar =
                      await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'Encerrar campanha?',
                        ),
                        content: const Text(
                          'A campanha deixará de aparecer para os usuários.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(
                                  context,
                                  false,
                                ),
                            child:
                                const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                Navigator.pop(
                                  context,
                                  true,
                                ),
                            child:
                                const Text('Encerrar'),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmar != true) return;

                  await _campanhaService
                      .encerrarCampanha(
                    widget.campanhaId,
                  );

                  if (!mounted) return;

                  Navigator.pop(context);
                },
                child: const Text(
                  'Encerrar Campanha',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}