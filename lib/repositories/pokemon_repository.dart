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
      try {
        result.add(Pokemon.fromJson(entry as Map<String, dynamic>));
      } catch (_) {}
    }
    _cache = result;
    return result;
  }
}
