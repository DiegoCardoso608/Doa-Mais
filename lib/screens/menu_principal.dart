import 'package:flutter/material.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doa+'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bem-vindo ao Doa+',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {},

              child: const Text('Doar'),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {},

              child: const Text('Campanhas'),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {},

              child: const Text('Pesquisar'),
            ),
          ],
        ),
      ),
    );
  }
}