import 'package:flutter/material.dart';

class CadastroPF extends StatefulWidget {
  const CadastroPF({super.key});

  @override
  State<CadastroPF> createState() => _CadastroPFState();
}

class _CadastroPFState extends State<CadastroPF> {

  final nomeController = TextEditingController();
  final sobrenomeController = TextEditingController();
  final ruaController = TextEditingController();
  final bairroController = TextEditingController();
  final numeroController = TextEditingController();
  final contatoController = TextEditingController();
  final senhaController = TextEditingController();

  String? dia;
  String? mes;
  String? ano;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFFB7D3D8),
        elevation: 0,
        title: const Text("Cadastro PF"),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // TOPO
            Container(
              height: 120,
              width: double.infinity,
              color: const Color(0xFFB7D3D8),
              alignment: Alignment.center,
              child: const Text(
                "Criar Conta",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [

                  // Nome e Sobrenome
                  TextField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      labelText: "Nome",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: sobrenomeController,
                    decoration: const InputDecoration(
                      labelText: "Sobrenome",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Data de nascimento
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Data de Nascimento",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          hint: const Text("Dia"),
                          items: List.generate(31, (index) {
                            final d = (index + 1).toString();
                            return DropdownMenuItem(value: d, child: Text(d));
                          }),
                          onChanged: (value) => dia = value,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          hint: const Text("Mês"),
                          items: List.generate(12, (index) {
                            final m = (index + 1).toString();
                            return DropdownMenuItem(value: m, child: Text(m));
                          }),
                          onChanged: (value) => mes = value,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          hint: const Text("Ano"),
                          items: List.generate(100, (index) {
                            final a = (2026 - index).toString();
                            return DropdownMenuItem(value: a, child: Text(a));
                          }),
                          onChanged: (value) => ano = value,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Endereço
                  TextField(
                    controller: ruaController,
                    decoration: const InputDecoration(
                      labelText: "Rua",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: bairroController,
                    decoration: const InputDecoration(
                      labelText: "Bairro",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: numeroController,
                    decoration: const InputDecoration(
                      labelText: "Número",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 20),

                  // Contato
                  TextField(
                    controller: contatoController,
                    decoration: const InputDecoration(
                      labelText: "Email ou Telefone",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Senha
                  TextField(
                    controller: senhaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Senha",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Botão
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // lógica futura (Firebase/MySQL)
                      },
                      child: const Text("Cadastrar"),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}