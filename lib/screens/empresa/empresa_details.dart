import 'package:flutter/material.dart';
import '../../models/empresa_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EmpresaDetails extends StatelessWidget {

  final EmpresaModel empresa;

  const EmpresaDetails({
    super.key,
    required this.empresa,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // BANNER

              Stack(
                children: [

                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: Image.asset(
                      empresa.bannerUrl,
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Container(
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      color: Colors.black.withOpacity(0.25),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // NOME

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  empresa.nome,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFF4A261),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // CARD DESCRIÇÃO

              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      empresa.descricao,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Text(
                      empresa.campanha,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // CARD ITENS

              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      'Itens Aceitos:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    ...empresa.itens.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // LOCALIZAÇÃO

              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      empresa.endereco,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                 ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: SizedBox(
    height: 220,
    width: double.infinity,

    child: GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
          empresa.latitude,
          empresa.longitude,
        ),
        zoom: 15,
      ),

      markers: {
        Marker(
          markerId: const MarkerId('empresa'),

          position: LatLng(
            empresa.latitude,
            empresa.longitude,
          ),
        ),
      },
    ),
  ),
),

                    const SizedBox(height: 20),

                    Text(
                      empresa.horario,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      empresa.telefone,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildCard({required Widget child}) {

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
}