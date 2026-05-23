// lib/screens/menu_principal.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {

  final TextEditingController pesquisaController =
      TextEditingController();

  String categoriaSelecionada = "";

  final List<Map<String, dynamic>> categorias = [
    {
      "nome": "Sangue",
      "icone": "🩸",
    },
    {
      "nome": "Roupa",
      "icone": "👕",
    },
    {
      "nome": "Móveis",
      "icone": "🛋️",
    },
    {
      "nome": "Comida",
      "icone": "🍴",
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF2F2F2),

      body: SafeArea(

        child: Column(

          children: [

            // TOPO
            Container(

              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 30,
              ),

              decoration: const BoxDecoration(
                color: Color(0xFFD7EEF3),
              ),

              child: Column(

                children: [

                  // LOGO
                  Column(
                    children: [

                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,

                        child: Icon(
                          Icons.volunteer_activism,
                          color: Colors.orange,
                          size: 55,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Doa+",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // TEXTO
                  const Text(
                    "Olá! Diego Você Gostaria De Doar Hoje?",
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5BB8C9),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // CATEGORIAS
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround,

                    children: categorias.map((categoria) {

                      final bool selecionado =
                          categoriaSelecionada ==
                              categoria['nome'];

                      return GestureDetector(

                        onTap: () {

                          setState(() {

                            if (categoriaSelecionada ==
                                categoria['nome']) {

                              categoriaSelecionada = "";

                            } else {

                              categoriaSelecionada =
                                  categoria['nome'];
                            }
                          });
                        },

                        child: Column(

                          children: [

                            Container(

                              width: 75,
                              height: 75,

                              decoration: BoxDecoration(

                                color: selecionado
                                    ? const Color(0xFF5BB8C9)
                                    : Colors.white,

                                shape: BoxShape.circle,
                              ),

                              child: Center(

                                child: Text(
                                  categoria['icone'],
                                  style: const TextStyle(
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // PESQUISA
            Padding(

              padding: const EdgeInsets.all(20),

              child: Container(

                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(35),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 6,
                    ),
                  ],
                ),

                child: Row(

                  children: [

                    Expanded(

                      child: TextField(

                        controller: pesquisaController,

                        decoration: const InputDecoration(
                          hintText:
                              "Pesquisar ONG, Instituição",
                          border: InputBorder.none,
                        ),

                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),

                    const Icon(
                      Icons.search,
                      size: 35,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),

            // CAMPANHAS
            Expanded(

              child: StreamBuilder<QuerySnapshot>(

                stream: FirebaseFirestore.instance
                    .collection('campanhas')
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
                        "Nenhuma campanha encontrada.",
                      ),
                    );
                  }

                  var campanhas = snapshot.data!.docs;

                  // PESQUISA
                  campanhas = campanhas.where((campanha) {

                    final titulo =
                        campanha['titulo']
                            .toString()
                            .toLowerCase();

                    final pesquisa =
                        pesquisaController.text
                            .toLowerCase();

                    return titulo.contains(pesquisa);

                  }).toList();

                  // FILTRO
                  if (categoriaSelecionada.isNotEmpty) {

                    campanhas =
                        campanhas.where((campanha) {

                      final categoria =
                          campanha['categoria'];

                      return categoria ==
                          categoriaSelecionada;

                    }).toList();
                  }

                  return ListView.builder(

                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 120,
                    ),

                    itemCount: campanhas.length,

                    itemBuilder: (context, index) {

                      final campanha = campanhas[index];

                      return Container(

                        margin:
                            const EdgeInsets.only(bottom: 20),

                        decoration: BoxDecoration(

                          color: const Color(0xFFE8E8E8),

                          borderRadius:
                              BorderRadius.circular(25),
                        ),

                        child: Row(

                          children: [

                            // IMAGEM
                            ClipRRect(

                              borderRadius:
                                  const BorderRadius.only(
                                topLeft:
                                    Radius.circular(25),
                                bottomLeft:
                                    Radius.circular(25),
                              ),

                              child: campanha['imagem'] != ""

                                  ? Image.network(

                                      campanha['imagem'],

                                      width: 140,
                                      height: 170,

                                      fit: BoxFit.cover,
                                    )

                                  : Container(

                                      width: 140,
                                      height: 170,

                                      color:
                                          Colors.grey[300],

                                      child: const Center(

                                        child: Icon(
                                          Icons.image,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                            ),

                            // TEXTO
                            Expanded(

                              child: Padding(

                                padding:
                                    const EdgeInsets.all(15),

                                child: Column(

                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [

                                    Text(

                                      campanha['titulo'],

                                      style:
                                          const TextStyle(
                                        fontSize: 18,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(
                                        height: 12),

                                    Row(

                                      children: [

                                        const Text(
                                          "📍 ",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),

                                        Expanded(

                                          child: Text(

                                            campanha[
                                                'empresaNome'],

                                            style:
                                                const TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                                  FontWeight
                                                      .w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                        height: 10),

                                    if (campanha['meta'] !=
                                        null)

                                      Row(

                                        children: [

                                          const Text(
                                            "🎯 ",
                                            style:
                                                TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),

                                          Text(

                                            "Meta: ${campanha['meta']}",

                                            style:
                                                const TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                                  FontWeight
                                                      .w600,
                                            ),
                                          ),
                                        ],
                                      ),

                                    const SizedBox(
                                        height: 14),

                                    Row(

                                      children: [

                                        Container(

                                          width: 16,
                                          height: 16,

                                          decoration:
                                              const BoxDecoration(
                                            color: Colors.blue,
                                            shape:
                                                BoxShape.circle,
                                          ),
                                        ),

                                        const SizedBox(
                                            width: 8),

                                        const Text(

                                          "Aceitando Doações",

                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // MENU INFERIOR
      bottomNavigationBar: Container(

        margin: const EdgeInsets.all(20),

        height: 75,

        decoration: BoxDecoration(

          color: const Color(0xFFD7EEF3),

          borderRadius:
              BorderRadius.circular(40),
        ),

        child: const Row(

          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,

          children: [

            Icon(
              Icons.home,
              size: 38,
              color: Colors.white,
            ),

            Icon(
              Icons.search,
              size: 38,
              color: Colors.white,
            ),

            Icon(
              Icons.person,
              size: 38,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}