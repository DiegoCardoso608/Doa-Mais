import 'package:flutter/material.dart';

class EmpresaLogin extends StatelessWidget {
  const EmpresaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Empresa")),
      body: const Center(child: Text("Tela de Login Empresa")),
    );
  }
}