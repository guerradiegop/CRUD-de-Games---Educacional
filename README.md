# CRUD de Games — Educacional

Mini projeto Flutter para controle de jogos, com interface clean, Material 3 e persistência local em SQLite.

## Funcionalidades

- Cadastro de jogos
- Listagem dos jogos cadastrados
- Edição de registros
- Exclusão com confirmação
- Status: Quero jogar, Jogando e Finalizado
- Nota de 0 a 10
- Observações
- Banco de dados SQLite local
- Feedback visual com SnackBar
- Estado vazio e pull-to-refresh
- Suporte a Windows e navegadores Web

## Plataformas suportadas

- Android/iOS: `sqflite` nativo
- Windows: SQLite via `sqflite_common_ffi`
- Web: SQLite/WASM via `sqflite_common_ffi_web`, persistido no IndexedDB do navegador

No navegador o projeto usa o modo sem Web Worker e carrega o `sqlite3.wasm` compatível diretamente do release oficial do pacote `sqlite3`. Assim não é necessário executar o comando manual `sqflite_common_ffi_web:setup` antes de `flutter run`.

> Requisito: Dart 3.12 ou superior, conforme as versões atuais das dependências multiplataforma utilizadas pelo projeto.

## Estrutura

```text
lib/
├── database/
│   ├── database_helper.dart
│   ├── database_platform.dart
│   ├── database_platform_io.dart
│   └── database_platform_web.dart
├── models/
│   └── game.dart
├── pages/
│   ├── game_form_page.dart
│   └── home_page.dart
└── main.dart

web/
├── index.html
└── manifest.json

windows/
├── CMakeLists.txt
├── flutter/
└── runner/
```

## Tecnologias

- Flutter
- Dart
- Material 3
- sqflite
- sqflite_common_ffi
- sqflite_common_ffi_web
- sqlite3
- path

## Como executar

1. Clone o repositório:

```bash
git clone https://github.com/guerradiegop/CRUD-de-Games---Educacional.git
cd CRUD-de-Games---Educacional
```

2. Instale as dependências:

```bash
flutter pub get
```

3. Verifique os dispositivos disponíveis:

```bash
flutter devices
```

4. Execute normalmente e escolha um dispositivo quando solicitado:

```bash
flutter run
```

### Windows

É necessário estar no Windows com o suporte desktop do Flutter habilitado e Visual Studio instalado com a carga de trabalho **Desktop development with C++**.

```bash
flutter config --enable-windows-desktop
flutter run -d windows
```

### Navegador

Com Chrome ou Edge instalado:

```bash
flutter run -d chrome
```

ou:

```bash
flutter run -d edge
```

Durante a primeira inicialização Web é necessário acesso à internet para carregar o binário oficial `sqlite3.wasm`. Os dados do CRUD permanecem armazenados localmente no IndexedDB do navegador.

## Banco de dados

A aplicação cria automaticamente um banco lógico chamado `games.db` com a tabela:

```sql
CREATE TABLE games (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  platform TEXT NOT NULL,
  status TEXT NOT NULL,
  rating REAL,
  notes TEXT NOT NULL DEFAULT ''
);
```

No Windows o banco é um arquivo SQLite local. No Web, o sistema de arquivos virtual do SQLite é persistido dentro do IndexedDB do navegador.

## Objetivo educacional

O projeto foi mantido propositalmente simples para demonstrar, de forma didática, o fluxo completo de um CRUD em Flutter com armazenamento SQL local e princípios básicos de UI/UX em múltiplas plataformas.
