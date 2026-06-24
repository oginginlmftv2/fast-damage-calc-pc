class Move {
  final String id;
  final String name;
  final String type;
  final String category;
  final int power;
  final int accuracy;

  const Move({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.power,
    required this.accuracy,
  });

  factory Move.fromJson(Map<String, dynamic> json) {
    return Move(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      category: json['category'] as String,
      power: json['power'] as int,
      accuracy: json['accuracy'] as int,
    );
  }
}
