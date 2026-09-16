class Game {
  final int? id;
  final String name;
  final String platform;
  final String status;
  final double? rating;
  final String notes;

  const Game({
    this.id,
    required this.name,
    required this.platform,
    required this.status,
    this.rating,
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'platform': platform,
      'status': status,
      'rating': rating,
      'notes': notes,
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: _toInt(map['id']),
      name: map['name']?.toString() ?? '',
      platform: map['platform']?.toString() ?? '',
      status: map['status']?.toString() ?? 'Quero jogar',
      rating: _toDouble(map['rating']),
      notes: map['notes']?.toString() ?? '',
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
