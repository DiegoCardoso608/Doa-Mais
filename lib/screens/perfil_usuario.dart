import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/telefone_formatter.dart';
import 'main_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PerfilUsuario extends StatefulWidget {
  const PerfilUsuario({super.key});

  @override
  State<PerfilUsuario> createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  final nomeController = TextEditingController();
  final sobrenomeController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final ruaController = TextEditingController();
  final bairroController = TextEditingController();
  final numeroController = TextEditingController();
  final nascimentoController = TextEditingController();

  bool _isLoading = true;
  bool _verificado = false;
  String? _erro;
  String _fotoPerfil = '';

  @override
  void initState() {
    super.initState();
    carregarUsuario();
  }

  Future<void> carregarUsuario() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .get();

      final dados = doc.data();

      setState(() {
        nomeController.text = dados?['nome'] ?? '';
        sobrenomeController.text = dados?['sobrenome'] ?? '';
        emailController.text = dados?['email'] ?? '';
        telefoneController.text = dados?['telefone'] ?? '';
        ruaController.text = dados?['rua'] ?? '';
        bairroController.text = dados?['bairro'] ?? '';
        numeroController.text = dados?['numero'] ?? '';
        nascimentoController.text = dados?['dataNascimento'] ?? '';
        _fotoPerfil = dados?['fotoPerfil'] ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _erro = 'Erro ao carregar perfil: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> salvarPerfil() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .update({
        'nome': nomeController.text.trim(),
        'sobrenome': sobrenomeController.text.trim(),
        'telefone': telefoneController.text.trim(),
        'rua': ruaController.text.trim(),
        'bairro': bairroController.text.trim(),
        'numero': numeroController.text.trim(),
        'dataNascimento': nascimentoController.text.trim(),
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

  Future<void> alterarSenha() async {
    try {
      final email = FirebaseAuth.instance.currentUser!.email!;

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foi enviado um e-mail para redefinição da senha.'),
          backgroundColor: Colors.green,
        ),
      );
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

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );
  }

  Future<void> _selecionarEUploadarFoto() async {
    try {
      final picker = ImagePicker();
      final imagem = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (imagem == null) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enviando imagem...'),
        ),
      );

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://api.cloudinary.com/v1_1/dx43mbrhl/image/upload',
        ),
      );

      request.fields['upload_preset'] = 'Doa-mais-Imagens';
      
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
            .collection('usuarios')
            .doc(uid)
            .update({
          'fotoPerfil': secureUrl,
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto enviada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        // Recarregar para mostrar a nova foto
        await carregarUsuario();
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao enviar foto'),
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
    nomeController.dispose();
    sobrenomeController.dispose();
    emailController.dispose();
    telefoneController.dispose();
    ruaController.dispose();
    bairroController.dispose();
    numeroController.dispose();
    nascimentoController.dispose();
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
          title: const Text('Meu Perfil'),
          backgroundColor: const Color(0xFFB7D3D8),
        ),
        body: Center(
          child: Text(_erro!),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: const Color(0xFFB7D3D8),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Seção superior com avatar e dados
            Container(
              color: const Color(0xFFB7D3D8),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: _fotoPerfil.isNotEmpty
                            ? NetworkImage(_fotoPerfil)
                            : null,
                        child: _fotoPerfil.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 48,
                                color: Colors.orange,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _selecionarEUploadarFoto,
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
                    '${nomeController.text} ${sobrenomeController.text}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    emailController.text,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
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
                  // Nome
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nome',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Sobrenome
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sobrenome',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: sobrenomeController,
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

                  // Rua
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Rua',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: ruaController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Bairro
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Bairro',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: bairroController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Número
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Número',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: numeroController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Data de Nascimento
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nascimento (DD/MM/YYYY)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nascimentoController,
                    decoration: const InputDecoration(
                      hintText: '01/01/2000',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botão Salvar Alterações
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: salvarPerfil,
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

                  // Botão Alterar Senha
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: alterarSenha,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Alterar Senha',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Botão Sair (Logout)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B6B),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Sair',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
