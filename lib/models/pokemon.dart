class Pokemon {
  final String id;
  final String name;
  final List<String> types;
  final Map<String, int> baseStats;
  final List<String> abilities;

  const Pokemon({
    required this.id,
    required this.name,
    required this.types,
    required this.baseStats,
    required this.abilities,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'] as String,
      name: json['name'] as String,
      types: List<String>.from(json['types'] as List),
      baseStats: Map<String, int>.from(json['baseStats'] as Map),
      abilities: List<String>.from(json['abilities'] as List),
    );
  }
}
