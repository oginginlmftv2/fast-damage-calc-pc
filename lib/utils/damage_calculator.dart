import 'type_chart.dart';

class DamageResult {
  final int min;
  final int max;
  final double minPercent;
  final double maxPercent;
  final int koCount;
  final List<int> rolls;

  const DamageResult({
    required this.min,
    required this.max,
    required this.minPercent,
    required this.maxPercent,
    required this.koCount,
    required this.rolls,
  });
}

DamageResult calcDamage({
  required int attackStat,
  required int defenseStat,
  required int power,
  required String moveType,
  required List<String> attackerTypes,
  required List<String> defenderTypes,
  required String? teraType,
  required int defenderHp,
  bool isBurned = false,
}) {
  const int level = 50;
  final double typeEff = getTypeEffectiveness(moveType, defenderTypes);

  // STAB
  double stab = 1.0;
  if (teraType != null && teraType.isNotEmpty) {
    if (teraType == moveType) {
      stab = attackerTypes.contains(moveType) ? 2.0 : 1.5;
    }
  } else if (attackerTypes.contains(moveType)) {
    stab = 1.5;
  }

  final double burnMod = isBurned ? 0.5 : 1.0;

  // ランダム乱数16個 (85〜100)
  final List<int> rolls = [];
  for (int r = 85; r <= 100; r++) {
    final int base = (((level * 2 ~/ 5 + 2) * power * attackStat ~/ defenseStat) ~/ 50 + 2);
    final int dmg = (base * stab * typeEff * burnMod * r / 100).floor();
    rolls.add(dmg);
  }

  final int minDmg = rolls.first;
  final int maxDmg = rolls.last;

  int koCount = 0;
  if (maxDmg > 0) {
    koCount = (defenderHp / maxDmg).ceil();
  }

  return DamageResult(
    min: minDmg,
    max: maxDmg,
    minPercent: defenderHp > 0 ? minDmg / defenderHp * 100 : 0,
    maxPercent: defenderHp > 0 ? maxDmg / defenderHp * 100 : 0,
    koCount: koCount,
    rolls: rolls,
  );
}
