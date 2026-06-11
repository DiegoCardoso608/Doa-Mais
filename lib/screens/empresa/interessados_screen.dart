import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InteressadosScreen extends StatelessWidget {
  final String campanhaId;
  final String campanhaTitulo;

  const InteressadosScreen({
    super.key,
    required this.campanhaId,
    required this.campanhaTitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEA),

      appBar: AppBar(
        title: Text(campanhaTitulo),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('interessados')
            .where(
              'campanhaId',
              isEqualTo: campanhaId,
            )
            .orderBy(
              'dataCriacao',
              descending: true,
            )
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum interessado ainda.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          }

          final interessados =
              snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: interessados.length,
            itemBuilder: (context, index) {
              final dados =
                  interessados[index].data()
                      as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.only(
                  bottom: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(
                      Icons.person,
                    ),
                  ),
                  title: Text(
                    dados['usuarioNome'] ?? '',
                  ),
                  subtitle: Text(
                    dados['usuarioEmail'] ?? '',
                  ),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: Text(
                      dados['status'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}