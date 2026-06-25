class Pokemon {
  final String id;
  final String name;
  final List<String> types;
  final Map<String, int> baseStats; // hp, atk, def, spa, spd, spe
  final List<String> abilities;

  const Pokemon({
    required this.id,
    required this.name,
    required this.types,
    required this.baseStats,
    required this.abilities,
  });

  static Map<String, int> _parseStats(Map<String, dynamic> raw) => {
    'hp':  raw['hp'] as int,
    'atk': raw['attack'] as int,
    'def': raw['defense'] as int,
    'spa': (raw['sp_attack'] ?? raw['spAttack']) as int,
    'spd': (raw['sp_defense'] ?? raw['spDefense']) as int,
    'spe': raw['speed'] as int,
  };

  // 新Geminiフォーマット（タイプ日本語・base_statsにアンダースコア）
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final entryId = json['id']?.toString() ?? json['slug'] ?? json['name'];
    final name = json['name'] as String;
    final types = List<String>.from(json['types'] as List);
    final baseStats = _parseStats(json['base_stats'] as Map<String, dynamic>);
    final abilities = List<String>.from(json['abilities'] as List);

    return Pokemon(
      id: entryId.toString(),
      name: name,
      types: types,
      baseStats: baseStats,
      abilities: abilities,
    );
  }

  // フォームバリアントを生成
  factory Pokemon.fromJsonForm(Map<String, dynamic> parent, Map<String, dynamic> form) {
    final baseName = parent['name'] as String;
    final formName = form['form_name'] as String;
    final types = List<String>.from(form['types'] as List);
    final baseStats = _parseStats(form['base_stats'] as Map<String, dynamic>);
    final abilities = List<String>.from(form['abilities'] as List);
    final entryId = '${parent["id"]}-$formName';

    return Pokemon(
      id: entryId,
      name: '$baseName（$formName）',
      types: types,
      baseStats: baseStats,
      abilities: abilities,
    );
  }
}
