import 'package:flutter/material.dart';

class LoginPF extends StatefulWidget {
  const LoginPF({super.key});

  @override
  State<LoginPF> createState() => _LoginPFState();
}

class _LoginPFState extends State<LoginPF> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool obscureSenha = true;

  void login() {
    String email = emailController.text;
    String senha = senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    //(MySQL ou Firebase)
    print("Email: $email");
    print("Senha: $senha");
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFEDEDED),

    // ✅ APPBAR NO LUGAR CERTO
    appBar: AppBar(
      backgroundColor: const Color(0xFFB7D3D8),
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      title: const Text(
        'Doa+',
        style: TextStyle(color: Colors.orange),
      ),
      centerTitle: true,
    ),


    body: SingleChildScrollView(
      child: Column(
        children: [
            // TOPO
            Container(
              height: 200,
              width: double.infinity,
              color: const Color(0xFFB7D3D8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.volunteer_activism, size: 60, color: Colors.orange),
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

            const SizedBox(height: 30),

            // CAMPO EMAIL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email, color: Colors.orange),
                  hintText: "Email ou Número",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // CAMPO SENHA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                controller: senhaController,
                obscureText: obscureSenha,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Colors.orange),
                  hintText: "Senha",
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureSenha ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureSenha = !obscureSenha;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // BOTÃO ENTRAR
            ElevatedButton(
              onPressed: login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Entrar"),
            ),

            const SizedBox(height: 20),

            const Text("Não possui conta?"),

            const SizedBox(height: 10),
            // BOTÃO CRIAR CONTA
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cadastro_pf');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Criar Conta"),
            ),
          ],
        ),
      ),
    );
  }
}

