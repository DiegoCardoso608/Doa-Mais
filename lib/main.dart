import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'screens/main_screen.dart';
import 'screens/login_pf.dart';
import 'screens/cadastro_pf.dart';
import 'screens/menu_principal.dart';

import 'screens/empresa/empresa_login.dart';
import 'screens/empresa/empresa_cadastro.dart';
import 'screens/empresa/menu_empresa.dart';
import 'screens/empresa/criar_campanha.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const DoaPlusApp());
}

class DoaPlusApp extends StatelessWidget {
  const DoaPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doa+',

      initialRoute: '/',

      routes: {
        '/': (context) => const MainScreen(),

        '/login_pf': (context) => const LoginPF(),

        '/empresa_login': (context) => const EmpresaLogin(),

        '/cadastro_pf': (context) => const CadastroPF(),

        '/menu_principal': (context) => const MenuPrincipal(),

        '/menu_empresa': (context) => const MenuEmpresa(),

        '/empresa_cadastro': (context) => const EmpresaCadastro(),

      '/criar_campanha': (context) => CriarCampanha(),      },
    );
  }
}
