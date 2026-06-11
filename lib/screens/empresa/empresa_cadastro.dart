import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/cnpj_formatter.dart';
import '../../utils/cnpj_validator.dart';
import '../../utils/telefone_formatter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EmpresaCadastro extends StatefulWidget {
  const EmpresaCadastro({super.key});

  @override
  State<EmpresaCadastro> createState() => _EmpresaCadastroState();
}

class _EmpresaCadastroState extends State<EmpresaCadastro> {

  final TextEditingController nomeController =
      TextEditingController();

  final TextEditingController razaoSocialController =
      TextEditingController();

  final TextEditingController responsavelController =
      TextEditingController();

  final TextEditingController telefoneController =
      TextEditingController();

  final TextEditingController enderecoController =
      TextEditingController();

  String? cep;

  double? latitude;

  double? longitude;

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
      razaoSocialController.text.isEmpty ||
      responsavelController.text.isEmpty ||
      telefoneController.text.isEmpty ||
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

    final cnpjLimpo = cnpjController.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    // Validar CNPJ
    if (!CnpjValidator.isValid(cnpjLimpo)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('CNPJ inválido'),
        ),
      );
      return;
    }

    // Verificar se CNPJ já existe
    final cnpjExiste = await FirebaseFirestore.instance
        .collection('empresas')
        .where('cnpj', isEqualTo: cnpjLimpo)
        .limit(1)
        .get();

    if (cnpjExiste.docs.isNotEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('CNPJ já cadastrado'),
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
              'uid': userCredential.user!.uid,
              'nomeFantasia':
                  nomeController.text.trim(),
              'razaoSocial':
                  razaoSocialController.text.trim(),
              'responsavel':
                  responsavelController.text.trim(),
              'cnpj':
                  cnpjLimpo,
              'telefone':
                  telefoneController.text.trim(),
              'email':
                  emailController.text.trim(),
              'endereco':
                  enderecoController.text.trim(),
              'horarioFuncionamento': '',
              'descricao': '',
              'fotoPerfil': '',
              'verificado': false,
              'emailVerificado': false,
              'cep':
                  cep,
              'latitude':
                  latitude,
              'longitude':
                  longitude,
              'tipo': 'empresa',
              'dataCriacao':
                  '$dia/$mes/$ano',
              'criadoEm':
                  Timestamp.now(),
            });

      // Enviar email de verificação
      await userCredential.user!.sendEmailVerification();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Empresa cadastrada com sucesso! Confirme seu e-mail.',
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

  @override
  void dispose() {
    nomeController.dispose();
    razaoSocialController.dispose();
    responsavelController.dispose();
    telefoneController.dispose();
    enderecoController.dispose();
    cnpjController.dispose();
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
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
                      controller: razaoSocialController,
                      decoration:
                          campo('Razão Social'),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: responsavelController,
                      decoration:
                          campo('Nome do Responsável'),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: telefoneController,
                      inputFormatters: [
                        TelefoneFormatter(),
                      ],
                      decoration:
                          campo('Telefone'),
                    ),

                    const SizedBox(height: 20),

                    GooglePlaceAutoCompleteTextField(
                      textEditingController:
                          enderecoController,

                      googleAPIKey:
                          'AIzaSyBN7s3AZHOcJ3Lt9I5V6Fziba_EEfSKjdk',

                      inputDecoration:
                          campo('Pesquisar endereço'),

                      debounceTime: 800,

                      countries: const ["br"],

                      isLatLngRequired: true,

                      getPlaceDetailWithLatLng: (prediction) {

                        print('========== PLACE DETAILS ==========');
                        print('Latitude: ${prediction.lat}');
                        print('Longitude: ${prediction.lng}');
                        print('===================================');

                        latitude = double.tryParse(
                          prediction.lat ?? '',
                        );

                        longitude = double.tryParse(
                          prediction.lng ?? '',
                        );
                      },

                      itemClick: (prediction) {

                        print('========== GOOGLE PLACES ==========');
                        print('Descrição: ${prediction.description}');
                        print('Place ID: ${prediction.placeId}');
                        print('Latitude: ${prediction.lat}');
                        print('Longitude: ${prediction.lng}');
                        print('===================================');

                        enderecoController.text =
                            prediction.description ?? '';

                        enderecoController.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                            offset:
                                enderecoController.text.length,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

TextField(
  controller: cnpjController,
  keyboardType: TextInputType.number,

  inputFormatters: [
    MaskTextInputFormatter(
      mask: '##.###.###/####-##',
      filter: {
        "#": RegExp(r'[0-9]')
      },
    ),
  ],

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