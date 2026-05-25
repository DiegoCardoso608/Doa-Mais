import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmpresaLogin extends StatefulWidget {
  const EmpresaLogin({super.key});

  @override
  State<EmpresaLogin> createState() => _EmpresaLoginState();
}

class _EmpresaLoginState extends State<EmpresaLogin> {

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController senhaController =
      TextEditingController();

  bool senhaVisivel = false;
  bool carregando = false;

  Future<void> loginEmpresa() async {

    if (
      emailController.text.isEmpty ||
      senhaController.text.isEmpty
    ) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos'),
        ),
      );

      return;
    }

    setState(() {
      carregando = true;
    });

    try {

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: senhaController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login realizado com sucesso'),
        ),
      );

      Navigator.pushReplacementNamed(
        context,
        '/menu_empresa',
      );

    } on FirebaseAuthException catch (e) {

      String mensagem = 'Erro ao fazer login';

      if (e.code == 'user-not-found') {
        mensagem = 'Empresa não encontrada';
      }

      if (e.code == 'wrong-password') {
        mensagem = 'Senha incorreta';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );

    }

    setState(() {
      carregando = false;
    });
  }

  InputDecoration campo(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF1F1F1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.black26,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.blue,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 40,
                  bottom: 40,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFD8EDF2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),

                child: Column(
                  children: [

const Icon(
  Icons.volunteer_activism,
  size: 80,
  color: Colors.orange,
),

const SizedBox(height: 10),

const Text(
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

              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [

                    const SizedBox(height: 30),

                    TextField(
                      controller: emailController,
                      decoration: campo('Email'),
                    ),

                    const SizedBox(height: 25),

                    TextField(
                      controller: senhaController,
                      obscureText: !senhaVisivel,

                      decoration: campo('Senha').copyWith(
                        suffixIcon: IconButton(
                          onPressed: () {

                            setState(() {
                              senhaVisivel =
                                  !senhaVisivel;
                            });

                          },

                          icon: Icon(
                            senhaVisivel
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 60,

                      child: ElevatedButton(
                        onPressed:
                            carregando
                                ? null
                                : loginEmpresa,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,

                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(40),
                          ),
                        ),

                        child: carregando
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Entrar',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 60,

                      child: ElevatedButton(
                        onPressed: () {

                          Navigator.pushNamed(
                            context,
                            '/empresa_cadastro',
                          );

                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFF2A24B),

                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(40),
                          ),
                        ),

                        child: const Text(
                          'Criar Conta',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      child: const Text(
                        'Voltar',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}