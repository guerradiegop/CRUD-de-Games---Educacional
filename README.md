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

## Estrutura

```text
lib/
├── database/
│   └── database_helper.dart
├── models/
│   └── game.dart
├── pages/
│   ├── game_form_page.dart
│   └── home_page.dart
└── main.dart
```

## Tecnologias

- Flutter
- Dart
- Material 3
- sqflite
- path

## Como executar

1. Clone o repositório:

```bash
git clone https://github.com/guerradiegop/CRUD-de-Games---Educacional.git
cd CRUD-de-Games---Educacional
```

2. Caso as pastas de plataforma ainda não existam, gere a estrutura nativa do Flutter:

```bash
flutter create .
```

3. Instale as dependências:

```bash
flutter pub get
```

4. Execute:

```bash
flutter run
```

## Banco de dados

A aplicação cria automaticamente um banco local chamado `games.db` com a tabela:

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

## Objetivo educacional

O projeto foi mantido propositalmente simples para demonstrar, de forma didática, o fluxo completo de um CRUD em Flutter com armazenamento SQL local e princípios básicos de UI/UX.
