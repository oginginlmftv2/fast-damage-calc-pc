import 'package:flutter/foundation.dart';
import '../models/pokemon.dart';
import '../models/move.dart';
import '../utils/damage_calculator.dart';
import '../utils/stat_calculator.dart';

class CalcState {
  final Pokemon? attacker;
  final Pokemon? defender;
  final Move? move;
  final String attackerNature;
  final Map<String, int> attackerEvs;
  final String defenderNature;
  final Map<String, int> defenderEvs;
  final String? attackerTeraType;
  final String? defenderTeraType;
  final DamageResult? result;

  const CalcState({
    this.attacker,
    this.defender,
    this.move,
    this.attackerNature = 'まじめ',
    this.attackerEvs = const {'hp': 0, 'atk': 0, 'def': 0, 'spa': 0, 'spd': 0, 'spe': 0},
    this.defenderNature = 'まじめ',
    this.defenderEvs = const {'hp': 0, 'atk': 0, 'def': 0, 'spa': 0, 'spd': 0, 'spe': 0},
    this.attackerTeraType,
    this.defenderTeraType,
    this.result,
  });

  CalcState copyWith({
    Pokemon? attacker,
    Pokemon? defender,
    Move? move,
    String? attackerNature,
    Map<String, int>? attackerEvs,
    String? defenderNature,
    Map<String, int>? defenderEvs,
    String? attackerTeraType,
    String? defenderTeraType,
    DamageResult? result,
  }) {
    return CalcState(
      attacker: attacker ?? this.attacker,
      defender: defender ?? this.defender,
      move: move ?? this.move,
      attackerNature: attackerNature ?? this.attackerNature,
      attackerEvs: attackerEvs ?? this.attackerEvs,
      defenderNature: defenderNature ?? this.defenderNature,
      defenderEvs: defenderEvs ?? this.defenderEvs,
      attackerTeraType: attackerTeraType ?? this.attackerTeraType,
      defenderTeraType: defenderTeraType ?? this.defenderTeraType,
      result: result ?? this.result,
    );
  }
}

class CalcProvider extends ChangeNotifier {
  CalcState _state = const CalcState();
  CalcState get state => _state;

  void setAttacker(Pokemon p) {
    _state = _state.copyWith(attacker: p);
    _calculate();
  }

  void setDefender(Pokemon p) {
    _state = _state.copyWith(defender: p);
    _calculate();
  }

  void setMove(Move m) {
    _state = _state.copyWith(move: m);
    _calculate();
  }

  void setAttackerNature(String nature) {
    _state = _state.copyWith(attackerNature: nature);
    _calculate();
  }

  void setDefenderNature(String nature) {
    _state = _state.copyWith(defenderNature: nature);
    _calculate();
  }

  void setAttackerEv(String stat, int value) {
    final evs = Map<String, int>.from(_state.attackerEvs);
    evs[stat] = value;
    _state = _state.copyWith(attackerEvs: evs);
    _calculate();
  }

  void setDefenderEv(String stat, int value) {
    final evs = Map<String, int>.from(_state.defenderEvs);
    evs[stat] = value;
    _state = _state.copyWith(defenderEvs: evs);
    _calculate();
  }

  void setAttackerTeraType(String? type) {
    _state = _state.copyWith(attackerTeraType: type);
    _calculate();
  }

  void setDefenderTeraType(String? type) {
    _state = _state.copyWith(defenderTeraType: type);
    _calculate();
  }

  void _calculate() {
    final a = _state.attacker;
    final d = _state.defender;
    final m = _state.move;
    if (a == null || d == null || m == null) {
      notifyListeners();
      return;
    }

    final isPhysical = m.category == 'ぶつり';
    final atkStat = calcStat(
      base: isPhysical ? a.baseStats['atk']! : a.baseStats['spa']!,
      ev: isPhysical ? _state.attackerEvs['atk']! : _state.attackerEvs['spa']!,
      nature: _state.attackerNature,
      stat: isPhysical ? 'atk' : 'spa',
    );
    final defStat = calcStat(
      base: isPhysical ? d.baseStats['def']! : d.baseStats['spd']!,
      ev: isPhysical ? _state.defenderEvs['def']! : _state.defenderEvs['spd']!,
      nature: _state.defenderNature,
      stat: isPhysical ? 'def' : 'spd',
    );
    final defHp = calcStat(
      base: d.baseStats['hp']!,
      ev: _state.defenderEvs['hp']!,
      nature: _state.defenderNature,
      stat: 'hp',
    );

    final result = calcDamage(
      attackStat: atkStat,
      defenseStat: defStat,
      power: m.power,
      moveType: m.type,
      attackerTypes: a.types,
      defenderTypes: d.types,
      teraType: _state.attackerTeraType,
      defenderHp: defHp,
    );

    _state = _state.copyWith(result: result);
    notifyListeners();
  }
}
