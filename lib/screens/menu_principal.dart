// lib/screens/menu_principal.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detalhe_campanha.dart';
import 'perfil_usuario.dart';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {

  final TextEditingController pesquisaController =
      TextEditingController();

  final ScrollController scrollController =
      ScrollController();

  final FocusNode pesquisaFocusNode =
      FocusNode();

  bool pesquisando = false;

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

    return PopScope(
      canPop: false,
      child: Scaffold(

        backgroundColor: const Color(0xFFF2F2F2),

        body: SafeArea(

          child: SingleChildScrollView(

            controller: scrollController,

          child: Column(

            children: [

              // TOPO
              AnimatedContainer(

                duration: const Duration(milliseconds: 350),

                width: double.infinity,

                padding: EdgeInsets.only(
                  top: pesquisando ? 10 : 20,
                  left: 20,
                  right: 20,
                  bottom: pesquisando ? 10 : 30,
                ),

                decoration: const BoxDecoration(
                  color: Color(0xFFD7EEF3),
                ),

                child: Column(

                  children: [

                    // BOTÃO PERFIL (topo direito)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.person),
                          color: const Color(0xFF5BB8C9),
                          iconSize: 28,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PerfilUsuario(),
                              ),
                            ).then((_) {
                              setState(() {});
                            });
                          },
                        ),
                      ],
                    ),

                    // LOGO
                    AnimatedOpacity(

                      duration:
                          const Duration(milliseconds: 250),

                      opacity: pesquisando ? 0 : 1,

                      child: AnimatedContainer(

                        duration:
                            const Duration(milliseconds: 300),

                        height: pesquisando ? 0 : 170,

                        child: Column(
                          children: [

                            CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.white,

                              child: const Icon(
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
                      ),
                    ),

                    // TEXTO
                    AnimatedOpacity(

                      duration:
                          const Duration(milliseconds: 250),

                      opacity: pesquisando ? 0 : 1,

                      child: AnimatedContainer(

                        duration:
                            const Duration(milliseconds: 300),

                        height: pesquisando ? 0 : 120,

                        child: const Text(
                          "Olá! Diego Você Gostaria De Doar Hoje?",
                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5BB8C9),
                          ),
                        ),
                      ),
                    ),

                    // CATEGORIAS
                    AnimatedOpacity(

                      duration:
                          const Duration(milliseconds: 250),

                      opacity: pesquisando ? 0 : 1,

                      child: AnimatedContainer(

                        duration:
                            const Duration(milliseconds: 300),

                        height: pesquisando ? 0 : 90,

                        child: Row(

                          mainAxisAlignment:
                              MainAxisAlignment.spaceAround,

                          children:
                              categorias.map((categoria) {

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

                              child: Container(

                                width: 75,
                                height: 75,

                                decoration: BoxDecoration(

                                  color: selecionado
                                      ? const Color(
                                          0xFF5BB8C9)
                                      : Colors.white,

                                  shape: BoxShape.circle,
                                ),

                                child: Center(

                                  child: Text(
                                    categoria['icone'],
                                    style:
                                        const TextStyle(
                                      fontSize: 35,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    // PESQUISA
                    AnimatedContainer(

                      duration:
                          const Duration(milliseconds: 350),

                      curve: Curves.easeInOut,

                      padding: EdgeInsets.only(
                        top: pesquisando ? 10 : 25,
                      ),

                      child: Container(

                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),

                        decoration: BoxDecoration(

                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(35),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.10),
                              blurRadius: 6,
                            ),
                          ],
                        ),

                        child: Row(

                          children: [

                            Expanded(

                              child: TextField(

                                controller:
                                    pesquisaController,

                                focusNode:
                                    pesquisaFocusNode,

                                decoration:
                                    InputDecoration(
                                  hintText:
                                      "Pesquisar ONG, Instituição",
                                  border:
                                      InputBorder.none,
                                  suffixIcon: pesquisando
                                      ? IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            pesquisaController.clear();

                                            setState(() {
                                              pesquisando = false;
                                            });

                                            pesquisaFocusNode.unfocus();
                                          },
                                        )
                                      : null,
                                ),

                                onTap: () async {

                                  setState(() {
                                    pesquisando = true;
                                  });

                                  await scrollController
                                      .animateTo(
                                    0,
                                    duration:
                                        const Duration(
                                      milliseconds: 450,
                                    ),
                                    curve:
                                        Curves.easeInOut,
                                  );
                                },

                                onChanged: (value) {
                                  setState(() {});
                                },

                                onSubmitted: (_) {

                                  setState(() {
                                    pesquisando = false;
                                  });

                                  pesquisaFocusNode
                                      .unfocus();
                                },
                              ),
                            ),

                            GestureDetector(

                              onTap: () {

                                setState(() {
                                  pesquisando = false;
                                });

                                pesquisaFocusNode
                                    .unfocus();
                              },

                              child: const Icon(
                                Icons.search,
                                size: 35,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // CAMPANHAS
              StreamBuilder<QuerySnapshot>(

                stream: FirebaseFirestore.instance
                    .collection('campanhas')
                    .snapshots(),

                builder: (context, snapshot) {

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {

                    return const Padding(
                      padding: EdgeInsets.all(50),
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {

                    return const Padding(

                      padding: EdgeInsets.all(50),

                      child: Center(
                        child: Text(
                          "Nenhuma campanha encontrada.",
                        ),
                      ),
                    );
                  }

                  var campanhas =
                      snapshot.data!.docs;

                  // PESQUISA
                  campanhas =
                      campanhas.where((campanha) {

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
                  if (categoriaSelecionada
                      .isNotEmpty) {

                    campanhas =
                        campanhas.where((campanha) {

                      final categoria =
                          campanha['categoria'];

                      return categoria ==
                          categoriaSelecionada;

                    }).toList();
                  }

                  return ListView.builder(

                    shrinkWrap: true,

                    physics:
                        const NeverScrollableScrollPhysics(),

                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 20,
                      bottom: 120,
                    ),

                    itemCount: campanhas.length,

                    itemBuilder:
    (context, index) {

  final campanha =
      campanhas[index];

  final dados =
      campanha.data() as Map;

  final imagem =
      dados.containsKey('imagem')
          ? (dados['imagem'] ?? '')
          : '';

  final meta =
      dados.containsKey('meta')
          ? dados['meta']
          : null;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetalheCampanha(
            campanhaId: campanha.id,
            campanha: campanha.data()
                as Map<String, dynamic>,
          ),
        ),
      );
    },

    child: Container(

      margin: const EdgeInsets.only(
        bottom: 20,
      ),

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

                              child:
                                  imagem.isNotEmpty

                                      ? Image.network(

                                          imagem,

                                          width: 140,
                                          height: 170,

                                          fit:
                                              BoxFit.cover,
                                        )

                                      : Container(

                                          width: 140,
                                          height: 170,

                                          color: Colors
                                              .grey[300],

                                          child:
                                              const Center(

                                            child: Icon(
                                              Icons
                                                  .image,
                                              size: 50,
                                              color: Colors
                                                  .grey,
                                            ),
                                          ),
                                        ),
                            ),

                            // TEXTO
                            Expanded(

                              child: Padding(

                                padding:
                                    const EdgeInsets
                                        .all(15),

                                child: Column(

                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [

                                    Text(

                                      campanha[
                                          'titulo'],

                                      style:
                                          const TextStyle(
                                        fontSize: 18,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 12,
                                    ),

                                    Row(

                                      children: [

                                        const Text(
                                          "📍 ",
                                          style:
                                              TextStyle(
                                            fontSize:
                                                18,
                                          ),
                                        ),

                                        Expanded(

                                          child: Text(

                                            campanha[
                                                'empresaNome'],

                                            style:
                                                const TextStyle(
                                              fontSize:
                                                  16,
                                              fontWeight:
                                                  FontWeight
                                                      .w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    if (meta != null)

                                      Row(

                                        children: [

                                          const Text(
                                            "🎯 ",
                                            style:
                                                TextStyle(
                                              fontSize:
                                                  18,
                                            ),
                                          ),

                                          Text(

                                            "Meta: $meta",

                                            style:
                                                const TextStyle(
                                              fontSize:
                                                  16,
                                              fontWeight:
                                                  FontWeight
                                                      .w600,
                                            ),
                                          ),
                                        ],
                                      ),

                                    const SizedBox(
                                      height: 14,
                                    ),

                                    Row(

                                      children: [

                                        Container(

                                          width: 16,
                                          height: 16,

                                          decoration:
                                              const BoxDecoration(
                                            color: Colors
                                                .blue,
                                            shape: BoxShape
                                                .circle,
                                          ),
                                        ),

                                        const SizedBox(
                                          width: 8,
                                        ),

                                        const Text(

                                          "Aceitando Doações",

                                          style:
                                              TextStyle(
                                            fontSize:
                                                16,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
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
                      ),
                    );
                  },
                  );
                },
              ),
            ],
          ),
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
              Icons.person,
              size: 38,
              color: Colors.white,
            ),
          ],
        ),
      ),
      ),
    );
  }
}