import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../repositories/pokemon_repository.dart';

class PokemonSearchField extends StatefulWidget {
  final String label;
  final Pokemon? value;
  final ValueChanged<Pokemon> onSelected;

  const PokemonSearchField({
    super.key,
    required this.label,
    this.value,
    required this.onSelected,
  });

  @override
  State<PokemonSearchField> createState() => _PokemonSearchFieldState();
}

class _PokemonSearchFieldState extends State<PokemonSearchField> {
  List<Pokemon> _all = [];
  List<Pokemon> _filtered = [];
  bool _loading = true;
  bool _open = false;
  final _ctrl = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _load();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) setState(() => _open = false);
    });
  }

  Future<void> _load() async {
    final list = await PokemonRepository.load();
    if (mounted) setState(() { _all = list; _loading = false; });
  }

  void _filter(String query) {
    setState(() {
      _open = query.isNotEmpty;
      _filtered = query.isEmpty
          ? []
          : _all.where((p) => p.name.contains(query)).toList();
    });
  }

  void _select(Pokemon p) {
    widget.onSelected(p);
    _ctrl.text = p.name;
    setState(() => _open = false);
    _focusNode.unfocus();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _ctrl,
          focusNode: _focusNode,
          enabled: !_loading,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: _loading ? '読み込み中...' : 'ポケモン名で検索',
            prefixIcon: const Icon(Icons.catching_pokemon),
            border: const OutlineInputBorder(),
            suffixText: widget.value?.types.join('/'),
          ),
          onChanged: _filter,
          onTap: () {
            if (_ctrl.text.isNotEmpty) _filter(_ctrl.text);
          },
        ),
        if (_open && _filtered.isNotEmpty)
          Card(
            margin: EdgeInsets.zero,
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _filtered.length > 8 ? 8 : _filtered.length,
              itemBuilder: (context, i) {
                final p = _filtered[i];
                return ListTile(
                  dense: true,
                  title: Text(p.name),
                  trailing: Text(
                    p.types.join('/'),
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: () => _select(p),
                );
              },
            ),
          ),
      ],
    );
  }
}
