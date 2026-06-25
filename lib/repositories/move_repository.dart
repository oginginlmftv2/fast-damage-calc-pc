import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/move.dart';

class MoveRepository {
  static List<Move>? _cache;

  static Future<List<Move>> load() async {
    if (_cache != null) return _cache!;
    final json = await rootBundle.loadString('assets/data/moves.json');
    final list = jsonDecode(json) as List;
    _cache = list.map((e) => Move.fromJson(e as Map<String, dynamic>)).toList();
    return _cache!;
  }
}
