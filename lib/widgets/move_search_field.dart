import 'package:flutter/material.dart';
import '../models/move.dart';
import '../repositories/move_repository.dart';

class MoveSearchField extends StatefulWidget {
  final Move? value;
  final ValueChanged<Move> onSelected;

  const MoveSearchField({super.key, this.value, required this.onSelected});

  @override
  State<MoveSearchField> createState() => _MoveSearchFieldState();
}

class _MoveSearchFieldState extends State<MoveSearchField> {
  List<Move> _all = [];
  List<Move> _filtered = [];
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
    final moves = await MoveRepository.load();
    if (mounted) setState(() { _all = moves; _loading = false; });
  }

  void _filter(String query) {
    setState(() {
      _open = query.isNotEmpty;
      _filtered = query.isEmpty
          ? []
          : _all.where((m) => m.name.contains(query)).toList();
    });
  }

  void _select(Move m) {
    widget.onSelected(m);
    _ctrl.text = m.name;
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
            labelText: '技',
            hintText: _loading ? '読み込み中...' : '技名で検索',
            prefixIcon: const Icon(Icons.flash_on),
            border: const OutlineInputBorder(),
            suffixIcon: widget.value != null
                ? Text(
                    widget.value!.category == 'ぶつり' ? '物' : '特',
                    style: TextStyle(
                      color: widget.value!.category == 'ぶつり'
                          ? Colors.orange
                          : Colors.lightBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
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
              itemCount: _filtered.length > 6 ? 6 : _filtered.length,
              itemBuilder: (context, i) {
                final m = _filtered[i];
                return ListTile(
                  dense: true,
                  title: Text(m.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(m.type, style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 8),
                      Text(
                        m.category == 'ぶつり' ? '物' : '特',
                        style: TextStyle(
                          fontSize: 12,
                          color: m.category == 'ぶつり'
                              ? Colors.orange
                              : Colors.lightBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${m.power}', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  onTap: () => _select(m),
                );
              },
            ),
          ),
      ],
    );
  }
}
