import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/pokemon.dart';

class PokemonRepository {
  static List<Pokemon>? _cache;

  static Future<List<Pokemon>> load() async {
    if (_cache != null) return _cache!;
    final json = await rootBundle.loadString('assets/data/pokemon.json');
    final list = jsonDecode(json) as List;

    final result = <Pokemon>[];
    for (final entry in list) {
      final baseName = entry['name'] as String;
      final forms = entry['forms'] as List;
      for (final form in forms) {
        try {
          result.add(Pokemon.fromGeminiForm(baseName, form as Map<String, dynamic>));
        } catch (_) {
          // 不正なフォームはスキップ
        }
      }
    }
    _cache = result;
    return result;
  }
}
