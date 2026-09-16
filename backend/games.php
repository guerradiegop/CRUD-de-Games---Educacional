<?php

declare(strict_types=1);

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type, Accept');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

$configFile = __DIR__ . '/config.php';
if (!file_exists($configFile)) {
    http_response_code(500);
    echo json_encode([
        'message' => 'Arquivo backend/config.php não encontrado. Copie config.example.php para config.php e informe os dados do MySQL.'
    ]);
    exit;
}

$config = require $configFile;

try {
    $dsn = sprintf(
        'mysql:host=%s;port=%d;dbname=%s;charset=%s',
        $config['host'],
        $config['port'],
        $config['database'],
        $config['charset'] ?? 'utf8mb4'
    );

    $pdo = new PDO($dsn, $config['username'], $config['password'], [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ]);

    $method = $_SERVER['REQUEST_METHOD'];
    $id = isset($_GET['id']) ? (int) $_GET['id'] : null;

    if ($method === 'GET') {
        $stmt = $pdo->query('SELECT id, name, platform, status, rating, notes FROM games ORDER BY name ASC');
        echo json_encode(['data' => $stmt->fetchAll()]);
        exit;
    }

    $body = json_decode(file_get_contents('php://input'), true) ?? [];

    if ($method === 'POST') {
        validateGame($body);

        $stmt = $pdo->prepare(
            'INSERT INTO games (name, platform, status, rating, notes) VALUES (:name, :platform, :status, :rating, :notes)'
        );
        $stmt->execute(gameParams($body));

        http_response_code(201);
        echo json_encode(['data' => ['id' => (int) $pdo->lastInsertId()]]);
        exit;
    }

    if ($method === 'PUT') {
        if (!$id) {
            throw new InvalidArgumentException('Informe o id do jogo na URL.');
        }

        validateGame($body);
        $params = gameParams($body);
        $params['id'] = $id;

        $stmt = $pdo->prepare(
            'UPDATE games SET name = :name, platform = :platform, status = :status, rating = :rating, notes = :notes WHERE id = :id'
        );
        $stmt->execute($params);

        echo json_encode(['message' => 'Jogo atualizado com sucesso.']);
        exit;
    }

    if ($method === 'DELETE') {
        if (!$id) {
            throw new InvalidArgumentException('Informe o id do jogo na URL.');
        }

        $stmt = $pdo->prepare('DELETE FROM games WHERE id = :id');
        $stmt->execute(['id' => $id]);

        echo json_encode(['message' => 'Jogo excluído com sucesso.']);
        exit;
    }

    http_response_code(405);
    echo json_encode(['message' => 'Método HTTP não suportado.']);
} catch (InvalidArgumentException $e) {
    http_response_code(422);
    echo json_encode(['message' => $e->getMessage()]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['message' => 'Falha ao acessar o MySQL. Verifique host, porta, banco, usuário e senha.']);
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode(['message' => 'Erro interno da API.']);
}

function validateGame(array $data): void
{
    if (trim((string) ($data['name'] ?? '')) === '') {
        throw new InvalidArgumentException('O nome do jogo é obrigatório.');
    }

    if (trim((string) ($data['platform'] ?? '')) === '') {
        throw new InvalidArgumentException('A plataforma é obrigatória.');
    }

    $allowedStatuses = ['Quero jogar', 'Jogando', 'Finalizado'];
    if (!in_array($data['status'] ?? '', $allowedStatuses, true)) {
        throw new InvalidArgumentException('Status inválido.');
    }

    if (isset($data['rating']) && $data['rating'] !== null) {
        $rating = (float) $data['rating'];
        if ($rating < 0 || $rating > 10) {
            throw new InvalidArgumentException('A nota deve estar entre 0 e 10.');
        }
    }
}

function gameParams(array $data): array
{
    return [
        'name' => trim((string) $data['name']),
        'platform' => trim((string) $data['platform']),
        'status' => (string) $data['status'],
        'rating' => ($data['rating'] ?? null) === null ? null : (float) $data['rating'],
        'notes' => trim((string) ($data['notes'] ?? '')),
    ];
}
