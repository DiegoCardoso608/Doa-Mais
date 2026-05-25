import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'screens/main_screen.dart';
import 'screens/login_pf.dart';
import 'screens/cadastro_pf.dart';
import 'screens/menu_principal.dart';

import 'models/empresa_model.dart';

import 'screens/empresa/empresa_details.dart';
import 'screens/empresa/empresa_cadastro.dart';
import 'screens/empresa/empresa_login.dart';

// EMPRESA TESTE
final EmpresaModel empresaTeste = EmpresaModel(
  nome: 'Usina Da Paz Cabanagem',

  bannerUrl: 'assets/images/usina.jpg',

  descricao:
      'Usina Da Paz - Cabanagem\nRecebendo Doações',

  campanha:
      'Campanha arrecadando roupas de frio para famílias em situação de vulnerabilidade.',

  itens: [
    '🧥 Casacos',
    '👕 Blusas',
    '👖 Calças',
    '🧦 Meias',
    '🛏️ Cobertores',
  ],

  endereco:
      'Av. Damasco, 37 - Cabanagem, Belém - PA',

  horario:
      'Seg - Sex | 08:00 - 17:00',

  telefone:
      '[ 91 9XXX-XXXX ]',

  latitude: -1.364576,
  longitude: -48.437214,
);

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
    '/menu_empresa': (context) => EmpresaDetails(
      empresa: empresaTeste,),
    '/empresa_login': (context) => const EmpresaLogin(),
    '/empresa_cadastro': (context) => const EmpresaCadastro(),
      },
    );
  }
}