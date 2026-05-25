import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmpresaCadastro extends StatefulWidget {
  const EmpresaCadastro({super.key});

  @override
  State<EmpresaCadastro> createState() => _EmpresaCadastroState();
}

class _EmpresaCadastroState extends State<EmpresaCadastro> {

  final TextEditingController nomeController =
      TextEditingController();

  final TextEditingController enderecoController =
      TextEditingController();

  final TextEditingController cnpjController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController senhaController =
      TextEditingController();

  bool senhaVisivel = false;
  bool carregando = false;

  String? dia;
  String? mes;
  String? ano;

  Future<void> cadastrarEmpresa() async {

    if (
      nomeController.text.isEmpty ||
      enderecoController.text.isEmpty ||
      cnpjController.text.isEmpty ||
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

      UserCredential userCredential =
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: senhaController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('empresas')
          .doc(userCredential.user!.uid)
          .set({

        'nomeFantasia':
            nomeController.text.trim(),

        'endereco':
            enderecoController.text.trim(),

        'cnpj':
            cnpjController.text.trim(),

        'email':
            emailController.text.trim(),

        'tipo': 'empresa',

        'dataCriacao':
            '$dia/$mes/$ano',

        'criadoEm':
            Timestamp.now(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Empresa cadastrada com sucesso!',
          ),
        ),
      );

      Navigator.pushReplacementNamed(
        context,
        '/empresa_login',
      );

    } on FirebaseAuthException catch (e) {

      String mensagem =
          'Erro ao cadastrar empresa';

      if (e.code == 'email-already-in-use') {
        mensagem = 'Email já está em uso';
      }

      if (e.code == 'weak-password') {
        mensagem = 'Senha muito fraca';
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
                  top: 30,
                  bottom: 30,
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

                    const SizedBox(height: 20),

                    const Text(
                      'Doa+',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF2A24B),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Cadastro Empresa',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24),

                child: Column(
                  children: [

                    TextField(
                      controller: nomeController,
                      decoration:
                          campo('Nome Fantasia'),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: enderecoController,

                      decoration: campo(
                        'Endereço',
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: cnpjController,
                      decoration: campo('CNPJ'),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: emailController,
                      decoration: campo('Email'),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: senhaController,

                      obscureText: !senhaVisivel,

                      decoration: campo('Senha')
                          .copyWith(

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
                                : cadastrarEmpresa,

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
                                'Finalizar',
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
                          Navigator.pop(context);
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
                          'Voltar',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          ),
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