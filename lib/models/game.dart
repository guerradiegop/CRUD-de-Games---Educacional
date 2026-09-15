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
      id: map['id'] as int?,
      name: map['name'] as String,
      platform: map['platform'] as String,
      status: map['status'] as String,
      rating: map['rating'] != null ? (map['rating'] as num).toDouble() : null,
      notes: map['notes'] as String? ?? '',
    );
  }
}
