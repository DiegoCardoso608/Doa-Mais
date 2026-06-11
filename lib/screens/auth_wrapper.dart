import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'main_screen.dart';
import 'menu_principal.dart';
import 'empresa/menu_empresa.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future _getInitialScreen() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const MainScreen();
    }

    final usuarioDoc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid)
        .get();

    if (usuarioDoc.exists) {
      return const MenuPrincipal();
    }

    final empresaDoc = await FirebaseFirestore.instance
        .collection('empresas')
        .doc(user.uid)
        .get();

    if (empresaDoc.exists) {
      return const MenuEmpresa();
    }

    await FirebaseAuth.instance.signOut();
    return const MainScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getInitialScreen(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return snapshot.data!;
      },
    );
  }
}
