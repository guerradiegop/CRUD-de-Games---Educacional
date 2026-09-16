# CRUD de Games — Educacional

Projeto Flutter de controle de jogos com interface Material 3 e persistência em **MySQL**, acessada por uma **API PHP/PDO**.

## Arquitetura

```text
Flutter (Windows/Web)
        |
        | HTTP/JSON
        v
API PHP (backend/games.php)
        |
        | PDO
        v
MySQL / MySQL Workbench
```

As credenciais do MySQL ficam somente no backend PHP. O Flutter recebe apenas a URL da API.

## 1. Criar o banco no MySQL Workbench

Abra o arquivo `database/schema.sql` no Workbench e execute o script. Ele cria o banco `games_db` e a tabela `games`.

## 2. Configurar host, porta, banco, usuário e senha

Copie:

```text
backend/config.example.php
```

para:

```text
backend/config.php
```

Depois edite:

```php
return [
    'host' => '127.0.0.1',
    'port' => 3306,
    'database' => 'games_db',
    'username' => 'root',
    'password' => '',
    'charset' => 'utf8mb4',
];
```

`backend/config.php` não deve ser enviado ao GitHub com credenciais reais.

## 3. Iniciar a API PHP

É necessário PHP com a extensão `pdo_mysql` habilitada.

Na raiz do projeto:

```bash
php -S localhost:8000
```

Teste no navegador:

```text
http://localhost:8000/backend/games.php
```

A resposta esperada inicialmente é:

```json
{"data":[]}
```

Você também pode hospedar a pasta `backend` em Apache/XAMPP/WAMP. Nesse caso, ajuste a URL da API no Flutter.

## 4. Executar o Flutter

```bash
flutter pub get
flutter run
```

Por padrão o app usa:

```text
http://localhost:8000/backend/games.php
```

Para usar outro servidor, passe a URL sem alterar o código:

```bash
flutter run -d windows --dart-define=API_URL=http://192.168.0.10:8000/backend/games.php
```

```bash
flutter run -d chrome --dart-define=API_URL=http://localhost:8000/backend/games.php
```

Em produção use HTTPS.

## Plataformas

- Windows: acesso à API pelo pacote `http`.
- Web/Chrome/Edge: acesso à mesma API por HTTP/HTTPS.
- O backend PHP conecta ao MySQL usando PDO.

## CRUD

- `GET /backend/games.php` — lista jogos
- `POST /backend/games.php` — cadastra jogo
- `PUT /backend/games.php?id=1` — atualiza jogo
- `DELETE /backend/games.php?id=1` — exclui jogo

## Estrutura principal

```text
backend/
├── config.example.php
└── games.php

database/
└── schema.sql

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

## Segurança

Nunca coloque host, usuário e senha do MySQL diretamente no Flutter, principalmente em aplicações Web. Código cliente pode ser inspecionado. A API funciona como a camada responsável por proteger a conexão e executar comandos SQL preparados.
