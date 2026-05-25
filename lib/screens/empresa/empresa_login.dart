import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmpresaLogin extends StatefulWidget {
  const EmpresaLogin({super.key});

  @override
  State<EmpresaLogin> createState() => _EmpresaLoginState();
}

class _EmpresaLoginState extends State<EmpresaLogin> {

  final TextEditingController cnpjController =
      TextEditingController();

  final TextEditingController senhaController =
      TextEditingController();

  bool senhaVisivel = false;
  bool carregando = false;

  Future<void> loginEmpresa() async {

    if (
      cnpjController.text.isEmpty ||
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

      final empresaQuery =
          await FirebaseFirestore.instance
              .collection('empresas')
              .where(
                'cnpj',
                isEqualTo: cnpjController.text.trim(),
              )
              .limit(1)
              .get();

      if (empresaQuery.docs.isEmpty) {
        throw Exception('CNPJ não encontrado');
      }

      final empresaData =
          empresaQuery.docs.first.data();

      final email = empresaData['email'];

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: senhaController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        '/menu_empresa',
      );

    } on FirebaseAuthException catch (e) {

      String mensagem = 'Erro ao fazer login';

      if (e.code == 'wrong-password') {
        mensagem = 'Senha incorreta';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );

    }

    setState(() {
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEA),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 50,
                  bottom: 30,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFAEC6CF),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),

                child: Column(
                  children: [

                    const Icon(
                      Icons.business,
                      size: 80,
                      color: Colors.orange,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Doa+ Empresa",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                ),

                child: Column(
                  children: [

                    TextField(
                      controller: cnpjController,
                      keyboardType: TextInputType.number,

                      decoration: InputDecoration(
                        hintText: 'CNPJ',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: senhaController,
                      obscureText: !senhaVisivel,

                      decoration: InputDecoration(
                        hintText: 'Senha',
                        filled: true,
                        fillColor: Colors.white,

                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),

                        suffixIcon: IconButton(
                          icon: Icon(
                            senhaVisivel
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),

                          onPressed: () {
                            setState(() {
                              senhaVisivel =
                                  !senhaVisivel;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),

                        onPressed:
                            carregando
                                ? null
                                : loginEmpresa,

                        child:
                            carregando
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Logar como Empresa',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextButton(
                      onPressed: () {

                        Navigator.pushNamed(
                          context,
                          '/empresa_cadastro',
                        );
                      },

                      child: const Text(
                        'Criar sua Empresa',
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