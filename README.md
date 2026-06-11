🧡 Doa+ — Conectando Quem Quer Ajudar Com Quem Precisa

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black"/>
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/Cloudinary-3448C5?style=for-the-badge&logo=cloudinary&logoColor=white"/>
  <img src="https://img.shields.io/badge/Google%20Maps-4285F4?style=for-the-badge&logo=googlemaps&logoColor=white"/>
</p>

Doa+ é um aplicativo mobile desenvolvido em Flutter que conecta pessoas físicas, ONGs e instituições para facilitar doações e ajudar quem mais precisa.




📱 Sobre o Projeto

O Doa+ é uma plataforma de doações que permite:


Pessoas físicas descobrirem campanhas de doação ativas perto delas, registrarem interesse e coordenarem a entrega de doações.
Empresas e instituições criarem e gerenciarem campanhas de doação, acompanharem interessados e divulgarem suas necessidades.



✨ Funcionalidades

👤 Área do Usuário (Pessoa Física)


Cadastro e login com e-mail/senha
Login social via Google
Recuperação de senha por e-mail
Feed de campanhas ativas com busca e filtro por categoria
Visualização detalhada de campanhas com mapa interativo
Registro de interesse em campanhas
Integração com Uber para entrega de doações
Perfil editável com foto de perfil (upload via Cloudinary)


🏢 Área da Empresa / Instituição


Cadastro com CNPJ validado e busca de endereço via Google Places
Login com CNPJ e senha
Recuperação de senha por e-mail
Dashboard com total de campanhas ativas
Criação de campanhas com imagem, categoria, itens necessários e localização
Edição e encerramento de campanhas
Lista de interessados por campanha em tempo real
Perfil da empresa editável com logo (upload via Cloudinary)


🗂️ Categorias de Doação


🩸 Sangue
👕 Roupa
🛋️ Móveis
🍴 Comida
🎒 Material Escolar
🧸 Brinquedos
📦 Outros



🛠️ Tecnologias Utilizadas

TecnologiaUsoFlutterFramework principal do appDartLinguagem de programaçãoFirebase AuthAutenticação de usuários e empresasCloud FirestoreBanco de dados em tempo realCloudinaryUpload e hospedagem de imagensGoogle Maps FlutterMapa interativo nas campanhasGoogle PlacesAutocomplete de endereços no cadastro de empresasGoogle Sign-InLogin socialurl_launcherAbertura do Google Maps e Uber externosimage_pickerSeleção de fotos da galeriamask_text_input_formatterMáscaras de CNPJ e telefone


🗃️ Estrutura do Projeto

lib/
├── main.dart                        # Ponto de entrada e rotas do app
├── screens/
│   ├── auth_wrapper.dart            # Roteamento pós-login (PF ou Empresa)
│   ├── main_screen.dart             # Tela inicial (escolha de perfil)
│   ├── login_pf.dart                # Login do usuário PF
│   ├── cadastro_pf.dart             # Cadastro do usuário PF
│   ├── menu_principal.dart          # Feed de campanhas para o usuário
│   ├── detalhe_campanha.dart        # Detalhes de uma campanha
│   ├── perfil_usuario.dart          # Perfil editável do usuário PF
│   └── empresa/
│       ├── empresa_login.dart       # Login da empresa
│       ├── empresa_cadastro.dart    # Cadastro da empresa
│       ├── menu_empresa.dart        # Dashboard da empresa
│       ├── criar_campanha.dart      # Criação de campanha
│       ├── editar_campanha.dart     # Edição de campanha
│       ├── interessados_screen.dart # Lista de interessados
│       └── perfil_empresa.dart      # Perfil editável da empresa
├── services/
│   ├── auth_service.dart            # Serviços de autenticação PF
│   ├── google_auth_service.dart     # Serviço de login Google
│   ├── campanha_service.dart        # CRUD de campanhas
│   ├── cloudinary_service.dart      # Upload de imagens
│   └── interessado_service.dart     # Registro de interesse
├── models/
│   └── empresa_model.dart           # Modelo de dados da empresa
└── utils/
    ├── telefone_formatter.dart      # Máscara de telefone
    ├── cnpj_formatter.dart          # Máscara de CNPJ
    └── cnpj_validator.dart          # Validação de CNPJ


🔥 Coleções no Firestore

firestore/
├── usuarios/          # Dados dos usuários PF
│   └── {uid}
│       ├── nome, sobrenome, email
│       ├── telefone, rua, bairro, numero
│       ├── dataNascimento, fotoPerfil
│       └── tipo: "pf"
│
├── empresas/          # Dados das empresas/instituições
│   └── {uid}
│       ├── nomeFantasia, razaoSocial, responsavel
│       ├── cnpj, email, telefone, endereco
│       ├── latitude, longitude
│       ├── horarioFuncionamento, descricao
│       ├── logoEmpresa, verificado
│       └── tipo: "empresa"
│
├── campanhas/         # Campanhas de doação
│   └── {id}
│       ├── empresaId, empresaNome
│       ├── titulo, descricao, categoria
│       ├── imagem, itensNecessarios[]
│       ├── enderecoColeta, latitude, longitude
│       ├── telefoneContato, status, meta
│       └── criadoEm
│
└── interessados/      # Registros de interesse em campanhas
    └── {id}
        ├── campanhaId, campanhaTitulo
        ├── empresaId
        ├── usuarioId, usuarioNome, usuarioEmail
        ├── status
        └── dataCriacao


🚀 Como Rodar o Projeto

Pré-requisitos


Flutter SDK (>= 3.0)
Dart SDK
Conta no Firebase
Conta no Cloudinary
Chave de API do Google Maps / Places


1. Clone o repositório

bashgit clone https://github.com/seu-usuario/doa-mais.git
cd doa-mais

2. Instale as dependências

bashflutter pub get

3. Configure o Firebase


Crie um projeto no Firebase Console
Ative Authentication (e-mail/senha e Google)
Ative o Cloud Firestore
Adicione os apps Android e/ou iOS ao projeto
Baixe o google-services.json (Android) e/ou GoogleService-Info.plist (iOS) e coloque nas pastas corretas
Execute:
