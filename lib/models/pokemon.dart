const _typeMap = {
  'Normal': 'ノーマル', 'Fire': 'ほのお', 'Water': 'みず', 'Electric': 'でんき',
  'Grass': 'くさ', 'Ice': 'こおり', 'Fighting': 'かくとう', 'Poison': 'どく',
  'Ground': 'じめん', 'Flying': 'ひこう', 'Psychic': 'エスパー', 'Bug': 'むし',
  'Rock': 'いわ', 'Ghost': 'ゴースト', 'Dragon': 'ドラゴン', 'Steel': 'はがね',
  'Dark': 'あく', 'Fairy': 'フェアリー',
};

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

  // Gemini形式（formsネスト）から1フォームぶんを生成
  factory Pokemon.fromGeminiForm(String baseName, Map<String, dynamic> form) {
    final formName = form['formName'] as String? ?? '通常';
    final isDefault = formName == '通常';
    final displayName = isDefault ? baseName : '$baseName（$formName）';
    final formId = form['formId'] as String? ?? baseName;

    final rawTypes = List<String>.from(form['types'] as List);
    final types = rawTypes.map((t) => _typeMap[t] ?? t).toList();

    final rawStats = Map<String, dynamic>.from(form['baseStats'] as Map);
    final baseStats = <String, int>{
      'hp':  rawStats['hp'] as int,
      'atk': rawStats['attack'] as int,
      'def': rawStats['defense'] as int,
      'spa': rawStats['spAttack'] as int,
      'spd': rawStats['spDefense'] as int,
      'spe': rawStats['speed'] as int,
    };

    final abilities = List<String>.from(form['abilities'] as List);

    return Pokemon(
      id: formId,
      name: displayName,
      types: types,
      baseStats: baseStats,
      abilities: abilities,
    );
  }
}
