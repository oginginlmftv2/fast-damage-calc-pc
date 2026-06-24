class PartyMember {
  final String pokemonId;
  final String nature;
  final Map<String, int> evs;
  final String teraType;
  final String ability;
  final String item;
  final List<String> moves;

  const PartyMember({
    required this.pokemonId,
    required this.nature,
    required this.evs,
    required this.teraType,
    required this.ability,
    required this.item,
    required this.moves,
  });

  factory PartyMember.empty(String pokemonId) {
    return PartyMember(
      pokemonId: pokemonId,
      nature: 'まじめ',
      evs: {'hp': 0, 'atk': 0, 'def': 0, 'spa': 0, 'spd': 0, 'spe': 0},
      teraType: '',
      ability: '',
      item: '',
      moves: [],
    );
  }

  Map<String, dynamic> toJson() => {
        'pokemonId': pokemonId,
        'nature': nature,
        'evs': evs,
        'teraType': teraType,
        'ability': ability,
        'item': item,
        'moves': moves,
      };

  factory PartyMember.fromJson(Map<String, dynamic> json) {
    return PartyMember(
      pokemonId: json['pokemonId'] as String,
      nature: json['nature'] as String,
      evs: Map<String, int>.from(json['evs'] as Map),
      teraType: json['teraType'] as String,
      ability: json['ability'] as String,
      item: json['item'] as String,
      moves: List<String>.from(json['moves'] as List),
    );
  }
}

class Party {
  final String id;
  final String name;
  final String regulation;
  final List<PartyMember> members;

  const Party({
    required this.id,
    required this.name,
    required this.regulation,
    required this.members,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'regulation': regulation,
        'members': members.map((m) => m.toJson()).toList(),
      };

  factory Party.fromJson(Map<String, dynamic> json) {
    return Party(
      id: json['id'] as String,
      name: json['name'] as String,
      regulation: json['regulation'] as String,
      members: (json['members'] as List)
          .map((m) => PartyMember.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }
}
