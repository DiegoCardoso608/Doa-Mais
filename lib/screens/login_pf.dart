import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/google_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPF extends StatefulWidget {
  const LoginPF({super.key});

  @override
  State<LoginPF> createState() => _LoginPFState();
}

class _LoginPFState extends State<LoginPF> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool obscureSenha = true;

  Future<void> _loginComGoogle() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Autenticando com Google...'),
        ),
      );

      final userCredential = await GoogleAuthService.signInWithGoogle();

      if (userCredential == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login cancelado'),
          ),
        );
        return;
      }

      // Verificar se usuário já existe no Firestore
      final uid = userCredential.user!.uid;
      final docSnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .get();

      // Se não existe, criar documento
      if (!docSnapshot.exists) {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(uid)
            .set({
          'nome': userCredential.user!.displayName ?? '',
          'email': userCredential.user!.email ?? '',
          'tipo': 'pf',
          'provider': 'google',
          'emailVerificado': true,
          'telefone': '',
          'rua': '',
          'bairro': '',
          'numero': '',
          'dataNascimento': '',
          'fotoPerfil': userCredential.user!.photoURL ?? '',
          'criadoEm': Timestamp.now(),
        });
      }

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/menu_principal',
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _mostrarRecuperacaoSenha() async {
    final emailController = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Recuperar Senha'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Digite seu e-mail para receber um link de recuperação'),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (emailController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Digite seu e-mail')),
                );
                return;
              }

              try {
                await FirebaseAuth.instance
                    .sendPasswordResetEmail(
                  email: emailController.text.trim(),
                );

                if (!mounted) return;

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Verifique seu e-mail para redefinir sua senha.',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e, s) {
                print('ERRO RESET SENHA: $e');
                print('STACK TRACE: $s');

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

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
  onPressed: () async {
    final erro = await AuthService().loginPF(
      email: emailController.text.trim(),
      senha: senhaController.text.trim(),
    );

if (erro == null) {
  Navigator.pushNamedAndRemoveUntil(
    context,
    '/menu_principal',
    (route) => false,
  );
} else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(erro),
        ),
      );
    }
  },

  child: const Text("Entrar"),
),

            const SizedBox(height: 8),

            // BOTÃO ESQUECEU SENHA
            TextButton(
              onPressed: _mostrarRecuperacaoSenha,
              child: const Text(
                'Esqueceu sua senha?',
                style: TextStyle(color: Colors.blue),
              ),
            ),

            const SizedBox(height: 16),

            // BOTÃO REENVIAR EMAIL
            TextButton(
              onPressed: () async {
                if (emailController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Digite seu email primeiro'),
                    ),
                  );
                  return;
                }

                final erro = await AuthService()
                    .reenviarEmailVerificacao();

                if (!mounted) return;

                if (erro == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'E-mail de confirmação reenviado.',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro: $erro'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text(
                'Reenviar e-mail de confirmação',
                style: TextStyle(color: Colors.blue),
              ),
            ),

            const SizedBox(height: 24),

            // DIVIDER
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey[300],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Ou',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // BOTÃO GOOGLE
            ElevatedButton.icon(
              onPressed: _loginComGoogle,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey[300]!),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              icon: const Icon(
                Icons.login,
                color: Colors.red,
              ),
              label: const Text(
                'Entrar com Google',
                style: TextStyle(color: Colors.black),
              ),
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

