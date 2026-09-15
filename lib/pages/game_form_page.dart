import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/game.dart';

class GameFormPage extends StatefulWidget {
  final Game? game;

  const GameFormPage({super.key, this.game});

  @override
  State<GameFormPage> createState() => _GameFormPageState();
}

class _GameFormPageState extends State<GameFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _platformController;
  late final TextEditingController _ratingController;
  late final TextEditingController _notesController;

  final _statuses = const ['Quero jogar', 'Jogando', 'Finalizado'];
  String _status = 'Quero jogar';
  bool _saving = false;

  bool get isEditing => widget.game != null;

  @override
  void initState() {
    super.initState();
    final game = widget.game;
    _nameController = TextEditingController(text: game?.name ?? '');
    _platformController = TextEditingController(text: game?.platform ?? '');
    _ratingController = TextEditingController(text: game?.rating?.toString() ?? '');
    _notesController = TextEditingController(text: game?.notes ?? '');
    _status = game?.status ?? 'Quero jogar';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _platformController.dispose();
    _ratingController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final ratingText = _ratingController.text.trim().replaceAll(',', '.');
    final game = Game(
      id: widget.game?.id,
      name: _nameController.text.trim(),
      platform: _platformController.text.trim(),
      status: _status,
      rating: ratingText.isEmpty ? null : double.parse(ratingText),
      notes: _notesController.text.trim(),
    );

    if (isEditing) {
      await DatabaseHelper.instance.updateGame(game);
    } else {
      await DatabaseHelper.instance.insertGame(game);
    }

    if (mounted) Navigator.pop(context, true);
  }

  InputDecoration _decoration(String label, IconData icon, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar jogo' : 'Novo jogo')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isEditing
                      ? 'Atualize as informações do jogo.'
                      : 'Adicione um jogo à sua coleção.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration(
                    'Nome do jogo',
                    Icons.sports_esports_outlined,
                    hint: 'Ex.: Hollow Knight',
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Informe o nome do jogo'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _platformController,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration(
                    'Plataforma',
                    Icons.devices_outlined,
                    hint: 'Ex.: PC, PS5, Xbox, Switch',
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Informe a plataforma'
                      : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: _decoration('Status', Icons.flag_outlined),
                  items: _statuses
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _status = value);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ratingController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: _decoration('Nota', Icons.star_outline, hint: '0 a 10'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    final rating = double.tryParse(value.replaceAll(',', '.'));
                    if (rating == null) return 'Informe uma nota válida';
                    if (rating < 0 || rating > 10) return 'A nota deve estar entre 0 e 10';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: _decoration(
                    'Observações',
                    Icons.notes_outlined,
                    hint: 'Comentários sobre o jogo...',
                  ),
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      _saving
                          ? 'Salvando...'
                          : isEditing
                              ? 'Salvar alterações'
                              : 'Adicionar jogo',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
