import 'nature_table.dart';

int calcStat({
  required int base,
  required int ev,
  required String nature,
  required String stat,
  int iv = 31,
  int level = 50,
}) {
  if (stat == 'hp') {
    return ((base * 2 + iv + ev ~/ 4) * level ~/ 100) + level + 10;
  }
  final raw = ((base * 2 + iv + ev ~/ 4) * level ~/ 100) + 5;
  return (raw * getNatureMultiplier(nature, stat)).floor();
}
