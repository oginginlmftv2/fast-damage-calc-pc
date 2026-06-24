const Map<String, Map<String, double>> natureTable = {
  'がんばりや': {},
  'さみしがり': {'atk': 1.1, 'def': 0.9},
  'ゆうかん': {'atk': 1.1, 'spe': 0.9},
  'いじっぱり': {'atk': 1.1, 'spa': 0.9},
  'やんちゃ': {'atk': 1.1, 'spd': 0.9},
  'ずぶとい': {'def': 1.1, 'atk': 0.9},
  'すなおな': {},
  'のんき': {'def': 1.1, 'spe': 0.9},
  'わんぱく': {'def': 1.1, 'spa': 0.9},
  'のうてんき': {'def': 1.1, 'spd': 0.9},
  'おくびょう': {'spe': 1.1, 'atk': 0.9},
  'せっかち': {'spe': 1.1, 'def': 0.9},
  'まじめ': {},
  'ようき': {'spe': 1.1, 'spa': 0.9},
  'むじゃき': {'spe': 1.1, 'spd': 0.9},
  'ひかえめ': {'spa': 1.1, 'atk': 0.9},
  'おっとり': {'spa': 1.1, 'def': 0.9},
  'うっかりや': {'spa': 1.1, 'spe': 0.9},
  'しんちょう': {'spa': 1.1, 'spd': 0.9},
  'なまいき': {'spd': 1.1, 'spe': 0.9},
  'おだやか': {'spd': 1.1, 'atk': 0.9},
  'おとなしい': {'spd': 1.1, 'def': 0.9},
  'れいせい': {'spd': 1.1, 'spe': 0.9},
  'しっかり': {'spd': 1.1, 'spa': 0.9},
  'きまぐれ': {},
};

double getNatureMultiplier(String nature, String stat) {
  return natureTable[nature]?[stat] ?? 1.0;
}
