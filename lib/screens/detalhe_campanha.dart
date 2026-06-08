import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetalheCampanha extends StatefulWidget {
  final String campanhaId;
  final Map<String, dynamic> campanha;

  const DetalheCampanha({
    super.key,
    required this.campanhaId,
    required this.campanha,
  });

  @override
  State createState() =>
      _DetalheCampanhaState();
}

class _DetalheCampanhaState
    extends State<DetalheCampanha> {

  bool enviando = false;

  Future registrarInteresse() async {
    try {
      final usuario =
          FirebaseAuth.instance.currentUser;

      if (usuario == null) {
        throw Exception(
          'Usuário não logado',
        );
      }

      await FirebaseFirestore.instance
          .collection('doacoes')
          .add({
        'campanhaId': widget.campanhaId,
        'usuarioId': usuario.uid,
        'data': Timestamp.now(),
        'status': 'interessado',
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Interesse registrado com sucesso!',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Erro: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final itens =
        (widget.campanha['itensNecessarios'] as List?)
            ?.cast<String>() ??
        [];

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      appBar: AppBar(
        title: Text(
          widget.campanha['titulo'] ?? 'Campanha',
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Text(
              widget.campanha['titulo'] ?? '',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Empresa: ${widget.campanha['empresaNome'] ?? ''}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Descrição',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.campanha['descricao'] ?? '',
            ),

            const SizedBox(height: 20),

            const Text(
              'Itens Necessários',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            ...itens.map(
              (item) => Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 8,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                    ),
                    const SizedBox(width: 10),
                    Text(item),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Telefone: ${widget.campanha['telefoneContato'] ?? ''}',
            ),

            const SizedBox(height: 10),

            Text(
              'Endereço: ${widget.campanha['enderecoColeta'] ?? ''}',
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: registrarInteresse,
                child: const Text(
                  'Quero Doar',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}