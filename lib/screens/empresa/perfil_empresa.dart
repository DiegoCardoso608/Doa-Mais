import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/telefone_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PerfilEmpresa extends StatefulWidget {
  const PerfilEmpresa({super.key});

  @override
  State<PerfilEmpresa> createState() => _PerfilEmpresaState();
}

class _PerfilEmpresaState extends State<PerfilEmpresa> {
  final nomeFantasiaController = TextEditingController();
  final razaoSocialController = TextEditingController();
  final responsavelController = TextEditingController();
  final cnpjController = TextEditingController();
  final telefoneController = TextEditingController();
  final enderecoController = TextEditingController();
  final horarioController = TextEditingController();
  final descricaoController = TextEditingController();

  bool _isLoading = true;
  bool _verificado = false;
  String? _erro;
  String _logoEmpresa = '';

  @override
  void initState() {
    super.initState();
    carregarEmpresa();
  }

  Future<void> carregarEmpresa() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final doc = await FirebaseFirestore.instance
          .collection('empresas')
          .doc(uid)
          .get();

      final dados = doc.data();

      setState(() {
        nomeFantasiaController.text = dados?['nomeFantasia'] ?? '';
        razaoSocialController.text = dados?['razaoSocial'] ?? '';
        responsavelController.text = dados?['responsavel'] ?? '';
        cnpjController.text = dados?['cnpj'] ?? '';
        telefoneController.text = dados?['telefone'] ?? '';
        enderecoController.text = dados?['endereco'] ?? '';
        horarioController.text = dados?['horarioFuncionamento'] ?? '';
        descricaoController.text = dados?['descricao'] ?? '';
        _logoEmpresa = dados?['logoEmpresa'] ?? '';
        _verificado = dados?['verificado'] ?? false;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _erro = 'Erro ao carregar perfil: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> salvarEmpresa() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection('empresas')
          .doc(uid)
          .update({
        'nomeFantasia': nomeFantasiaController.text.trim(),
        'razaoSocial': razaoSocialController.text.trim(),
        'responsavel': responsavelController.text.trim(),
        'telefone': telefoneController.text.trim(),
        'endereco': enderecoController.text.trim(),
        'horarioFuncionamento': horarioController.text.trim(),
        'descricao': descricaoController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil atualizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> sair() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/empresa_login',
      (route) => false,
    );
  }

  Future<void> _selecionarEUploadarLogo() async {
    try {
      final picker = ImagePicker();
      final imagem = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (imagem == null) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enviando logo...'),
        ),
      );

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://api.cloudinary.com/v1_1/dx43mbrhl/image/upload',
        ),
      );

      request.fields['upload_preset'] = 'doamais';

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imagem.path,
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonData = jsonDecode(responseString);
        final secureUrl = jsonData['secure_url'];

        // Salvar URL no Firestore
        final uid = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance
            .collection('empresas')
            .doc(uid)
            .update({
          'logoEmpresa': secureUrl,
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logo enviado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        // Recarregar para mostrar novo logo
        await carregarEmpresa();
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao enviar logo'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    nomeFantasiaController.dispose();
    razaoSocialController.dispose();
    responsavelController.dispose();
    cnpjController.dispose();
    telefoneController.dispose();
    enderecoController.dispose();
    horarioController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_erro != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Perfil da Empresa'),
          backgroundColor: const Color(0xFFAEC6CF),
        ),
        body: Center(
          child: Text(_erro!),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil da Empresa'),
        backgroundColor: const Color(0xFFAEC6CF),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Seção superior com avatar e dados
            Container(
              color: const Color(0xFFAEC6CF),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: _logoEmpresa.isNotEmpty
                            ? NetworkImage(_logoEmpresa)
                            : null,
                        child: _logoEmpresa.isEmpty
                            ? const Icon(
                                Icons.business,
                                size: 48,
                                color: Colors.orange,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _selecionarEUploadarLogo,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    nomeFantasiaController.text,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_verificado) ...[
                        const Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Instituição Verificada',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                      ] else ...[
                        const Icon(
                          Icons.pending,
                          color: Colors.orange,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Verificação Pendente',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Divisor
            Container(
              height: 1,
              color: Colors.grey[300],
            ),

            const SizedBox(height: 20),

            // Campos editáveis
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Nome Fantasia
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nome Fantasia',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nomeFantasiaController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Razão Social
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Razão Social',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: razaoSocialController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Responsável
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Responsável',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: responsavelController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Telefone
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Telefone',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: telefoneController,
                    inputFormatters: [TelefoneFormatter()],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // CNPJ (ReadOnly)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'CNPJ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: cnpjController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Endereço
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Endereço',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: enderecoController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Horário de Funcionamento
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Horário de Funcionamento',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: horarioController,
                    decoration: const InputDecoration(
                      hintText: '08:00 às 18:00',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Descrição
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Descrição',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descricaoController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Descrição da instituição',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botão Salvar Alterações
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: salvarEmpresa,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Salvar Alterações',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: sair,
                      icon: const Icon(Icons.logout),
                      label: const Text('Sair da Conta'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
