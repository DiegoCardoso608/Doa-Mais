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
