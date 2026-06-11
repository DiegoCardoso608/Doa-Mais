import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/interessado_service.dart';

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

  Future abrirGoogleMaps() async {
    final endereco =
        widget.campanha['enderecoColeta'] ?? '';

    final url =
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(endereco)}';

    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  Future abrirUber() async {

    final endereco =
        widget.campanha['enderecoColeta'] ?? '';

    final url =
        'https://m.uber.com/ul/?action=setPickup'
        '&pickup=my_location'
        '&dropoff[formatted_address]='
        '${Uri.encodeComponent(endereco)}';

    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  Future mostrarOpcoesEntrega() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                'Como deseja entregar sua doação?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.volunteer_activism,
                  ),
                  label: const Text(
                    'Entregar pessoalmente',
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.local_taxi,
                  ),
                  label: const Text(
                    'Chamar Uber',
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    abrirUber();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future registrarInteresse() async {
    setState(() {
      enviando = true;
    });

    try {
      final resultado =
          await InteressadoService().registrarInteresse(
        campanhaId: widget.campanhaId,
        campanhaTitulo:
            widget.campanha['titulo'] ?? '',
        empresaId: widget.campanha['empresaId'] ?? '',
      );

      if (!mounted) return;

      if (resultado == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Interesse registrado com sucesso!',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(resultado),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Erro: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          enviando = false;
        });
      }
    }
  }

  Widget buildCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFD8EDF2),
        borderRadius: BorderRadius.circular(28),
      ),
      child: child,
    );
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
        child: Column(
          children: [

            Stack(
              children: [

                ClipRRect(
                  borderRadius:
                      const BorderRadius.only(
                    bottomLeft:
                        Radius.circular(30),
                    bottomRight:
                        Radius.circular(30),
                  ),
                  child:
                      widget.campanha['imagem'] !=
                                  null &&
                          widget.campanha['imagem'] !=
                              ''
                          ? Image.network(
                              widget.campanha['imagem'],
                              height: 280,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 280,
                              color: Colors.grey,
                              child: const Center(
                                child: Icon(
                                  Icons.image,
                                  size: 100,
                                ),
                              ),
                            ),
                ),

                Container(
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.only(
                      bottomLeft:
                          Radius.circular(30),
                      bottomRight:
                          Radius.circular(30),
                    ),
                    color:
                        Colors.black.withOpacity(
                      0.25,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                widget.campanha['titulo'] ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFF4A261),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            buildCard(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    widget.campanha['descricao'] ??
                        '',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Empresa: ${widget.campanha['empresaNome'] ?? ''}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Categoria: ${widget.campanha['categoria'] ?? ''}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            buildCard(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  const Text(
                    'Itens Necessários',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  ...itens.map(
                    (item) => Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 8,
                      ),
                      child: Text(
                        item,
                        style:
                            const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            buildCard(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    widget.campanha[
                            'enderecoColeta'] ??
                        '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (widget.campanha['latitude'] != null &&
                      widget.campanha['longitude'] != null)

                    GestureDetector(
                      onTap: abrirGoogleMaps,

                      child: SizedBox(
                        height: 300,
                        child: GoogleMap(
                          initialCameraPosition:
                              CameraPosition(
                            target: LatLng(
                              (widget.campanha['latitude'] as num)
                                  .toDouble(),
                              (widget.campanha['longitude'] as num)
                                  .toDouble(),
                            ),
                            zoom: 15,
                          ),

                          markers: {
                            Marker(
                              markerId:
                                  const MarkerId('campanha'),
                              position: LatLng(
                                (widget.campanha['latitude'] as num)
                                    .toDouble(),
                                (widget.campanha['longitude'] as num)
                                    .toDouble(),
                              ),
                            ),
                          },
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 180,
                      alignment: Alignment.center,
                      child: const Text(
                        'Localização indisponível',
                      ),
                    ),

                  const SizedBox(height: 20),

                  Text(
                    widget.campanha[
                            'telefoneContato'] ??
                        '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child:
                    ElevatedButton.icon(
                  icon: const Icon(
                    Icons.volunteer_activism,
                  ),
                  label: const Text(
                    'Quero Doar',
                  ),
                  onPressed: () async {
                    await registrarInteresse();

                    if (!mounted) return;

                    mostrarOpcoesEntrega();
                  },
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}