import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/campanha_service.dart';
import '../../services/cloudinary_service.dart';

class CriarCampanha extends StatefulWidget {
  const CriarCampanha({super.key});

  @override
  State<CriarCampanha> createState() => _CriarCampanhaState();
}

class _CriarCampanhaState extends State<CriarCampanha> {
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

  Future<void> salvarCampanha() async {
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

      final uid =
          FirebaseAuth.instance.currentUser!.uid;

      final empresaDoc =
          await FirebaseFirestore.instance
              .collection('empresas')
              .doc(uid)
              .get();

      final empresaData = empresaDoc.data();

      if (empresaData == null) {
        throw Exception(
          'Empresa não encontrada.',
        );
      }

      await _campanhaService.criarCampanha(
        empresaId: uid,
        empresaNome:
            empresaData['nomeFantasia'] ?? '',
        titulo: tituloController.text.trim(),
        descricao:
            descricaoController.text.trim(),
        categoria: categoriaSelecionada,
        imagem: imagemUrl,
        itensNecessarios: itensNecessarios,
        enderecoColeta:
            empresaData['endereco'] ?? '',
        telefoneContato:
            telefoneController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Campanha criada com sucesso!',
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
        title: const Text('Nova Campanha'),
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
                        : salvarCampanha,
                child:
                    carregando
                        ? const CircularProgressIndicator(
                            color:
                                Colors.white,
                          )
                        : const Text(
                            'Criar Campanha',
                            style: TextStyle(
                              color:
                                  Colors.white,
                              fontSize: 18,
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