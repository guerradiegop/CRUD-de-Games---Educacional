import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/game.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static const String _apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:8000/backend/games.php',
  );

  Uri get _endpoint => Uri.parse(_apiUrl);

  Map<String, String> get _headers => const {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      };

  Future<List<Game>> getGames() async {
    final response = await http.get(_endpoint, headers: _headers);
    _ensureSuccess(response);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final items = decoded['data'] as List<dynamic>? ?? const [];

    return items
        .map((item) => Game.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<int> insertGame(Game game) async {
    final response = await http.post(
      _endpoint,
      headers: _headers,
      body: jsonEncode(game.toMap()..remove('id')),
    );
    _ensureSuccess(response);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decoded['data'] as Map<String, dynamic>?;
    return _parseInt(data?['id']) ?? 0;
  }

  Future<int> updateGame(Game game) async {
    if (game.id == null) {
      throw ArgumentError('O jogo precisa de um id para ser atualizado.');
    }

    final response = await http.put(
      _endpoint.replace(queryParameters: {'id': game.id.toString()}),
      headers: _headers,
      body: jsonEncode(game.toMap()..remove('id')),
    );
    _ensureSuccess(response);
    return 1;
  }

  Future<int> deleteGame(int id) async {
    final response = await http.delete(
      _endpoint.replace(queryParameters: {'id': id.toString()}),
      headers: _headers,
    );
    _ensureSuccess(response);
    return 1;
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;

    String message = 'Erro ${response.statusCode} ao acessar a API.';
    try {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      message = decoded['message']?.toString() ?? message;
    } catch (_) {
      // Mantem a mensagem padrao quando a resposta nao e JSON.
    }

    throw Exception(message);
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
