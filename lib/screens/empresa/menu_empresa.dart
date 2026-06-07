import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuEmpresa extends StatefulWidget {
  const MenuEmpresa({super.key});

  @override
  State<MenuEmpresa> createState() => _MenuEmpresaState();
}

class _MenuEmpresaState extends State<MenuEmpresa> {
  String nomeEmpresa = 'Empresa';
  int totalCampanhas = 0;

  List<QueryDocumentSnapshot> campanhas = [];

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) return;

    final empresaDoc = await FirebaseFirestore.instance
        .collection('empresas')
        .doc(usuario.uid)
        .get();

    final campanhasSnapshot =
        await FirebaseFirestore.instance
            .collection('campanhas')
            .where(
              'empresaId',
              isEqualTo: usuario.uid,
            )
            .get();

    setState(() {
      nomeEmpresa =
          empresaDoc.data()?['nomeFantasia'] ??
              'Empresa';

      campanhas = campanhasSnapshot.docs;

      totalCampanhas =
          campanhasSnapshot.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {


        final usuario = FirebaseAuth.instance.currentUser;

        debugPrint('UID EMPRESA: ${usuario?.uid}');
        debugPrint('EMAIL EMPRESA: ${usuario?.email}');


      final int totalDoacoes = 0;

    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEA),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // CABEÇALHO PADRÃO DO DOA+
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 60,
                bottom: 30,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFAEC6CF),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                children: const [
                  Icon(
                    Icons.volunteer_activism,
                    size: 80,
                    color: Colors.orange,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Doa+",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                nomeEmpresa ?? "Empresa",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                "Gerencie suas campanhas e acompanhe suas doações.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.teal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ESTATÍSTICAS
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD8E8ED),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(
                            totalCampanhas.toString(),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text("Campanhas"),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD8E8ED),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(
                            totalDoacoes.toString(),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text("Doações"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // NOVA CAMPANHA
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () async {
                  await Navigator.pushNamed(
                  context,
                 '/criar_campanha',
                  );

                  carregarDados();
            },
              child: const Text(
                "Nova Campanha",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 35),

            const Text(
              "Campanhas Ativas",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),

            const SizedBox(height: 20),

            if (campanhas.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8E8ED),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Nenhuma campanha criada ainda.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

            ...campanhas.map(
  (campanha) {
    final dados =
        campanha.data()
            as Map<String, dynamic>;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFD8E8ED),
          borderRadius:
              BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              dados['titulo'] ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Categoria: ${dados['categoria']}',
            ),

            Text(
              'Status: ${dados['status']}',
            ),

            Text(
              'Itens: ${(dados['itensNecessarios'] as List?)?.length ?? 0}',
            ),
          ],
        ),
      ),
    );
  },
),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}