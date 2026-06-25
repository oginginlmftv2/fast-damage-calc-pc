import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/calc_provider.dart';
import '../utils/damage_calculator.dart';
import '../utils/nature_table.dart';
import '../widgets/move_search_field.dart';
import '../widgets/pokemon_search_field.dart';

const List<String> kTeraTypes = [
  'ノーマル', 'ほのお', 'みず', 'でんき', 'くさ', 'こおり',
  'かくとう', 'どく', 'じめん', 'ひこう', 'エスパー', 'むし',
  'いわ', 'ゴースト', 'ドラゴン', 'あく', 'はがね', 'フェアリー',
];

class CalcPage extends StatelessWidget {
  const CalcPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalcProvider(),
      child: const _CalcPageBody(),
    );
  }
}

class _CalcPageBody extends StatelessWidget {
  const _CalcPageBody();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CalcProvider>().state;
    final result = state.result;
    final error = state.error;

    return Scaffold(
      appBar: AppBar(title: const Text('ダメージ計算')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionCard(title: '攻撃側', child: const _AttackerSection()),
            const SizedBox(height: 12),
            _SectionCard(title: '防御側', child: const _DefenderSection()),
            const SizedBox(height: 16),
            const _CalcButton(),
            const SizedBox(height: 12),
            if (error != null) _ErrorCard(message: error),
            if (result != null) _ResultCard(result: result),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

// ─── 攻撃側 ───────────────────────────────────────────

class _AttackerSection extends StatelessWidget {
  const _AttackerSection();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalcProvider>();
    final state = provider.state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PokemonSearchField(
          label: 'ポケモン',
          value: state.attacker,
          onSelected: provider.setAttacker,
        ),
        const SizedBox(height: 8),
        MoveSearchField(
          value: state.move,
          onSelected: provider.setMove,
        ),
        const SizedBox(height: 8),
        _NatureDropdown(
          value: state.attackerNature,
          onChanged: provider.setAttackerNature,
        ),
        const SizedBox(height: 8),
        _EvRow(
          label: '努力値',
          stats: const [('A(攻撃)', 'atk'), ('C(特攻)', 'spa')],
          evs: state.attackerEvs,
          onChanged: provider.setAttackerEv,
        ),
        const SizedBox(height: 8),
        _TeraTypeSelector(
          value: state.attackerTeraType,
          onChanged: provider.setAttackerTeraType,
        ),
      ],
    );
  }
}

// ─── 防御側 ───────────────────────────────────────────

class _DefenderSection extends StatelessWidget {
  const _DefenderSection();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalcProvider>();
    final state = provider.state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PokemonSearchField(
          label: 'ポケモン',
          value: state.defender,
          onSelected: provider.setDefender,
        ),
        const SizedBox(height: 8),
        _NatureDropdown(
          value: state.defenderNature,
          onChanged: provider.setDefenderNature,
        ),
        const SizedBox(height: 8),
        _EvRow(
          label: '努力値',
          stats: const [('H(HP)', 'hp'), ('B(防御)', 'def'), ('D(特防)', 'spd')],
          evs: state.defenderEvs,
          onChanged: provider.setDefenderEv,
        ),
        const SizedBox(height: 8),
        _TeraTypeSelector(
          value: state.defenderTeraType,
          onChanged: provider.setDefenderTeraType,
        ),
      ],
    );
  }
}

// ─── 性格ドロップダウン ────────────────────────────────

class _NatureDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _NatureDropdown({required this.value, required this.onChanged});

  static const _statAbbr = {'atk': 'A', 'def': 'B', 'spa': 'C', 'spd': 'D', 'spe': 'S'};

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: const InputDecoration(
        labelText: '性格',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      isExpanded: true,
      items: natureTable.keys.map((n) {
        final mods = natureTable[n]!;
        String suffix = '';
        if (mods.isNotEmpty) {
          final up = mods.entries.where((e) => e.value > 1).map((e) => _statAbbr[e.key] ?? e.key).join();
          final dn = mods.entries.where((e) => e.value < 1).map((e) => _statAbbr[e.key] ?? e.key).join();
          suffix = '  +$up/-$dn';
        }
        return DropdownMenuItem(
          value: n,
          child: Text('$n$suffix', style: const TextStyle(fontSize: 13)),
        );
      }).toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

// ─── 努力値入力 ────────────────────────────────────────

class _EvRow extends StatelessWidget {
  final String label;
  final List<(String, String)> stats;
  final Map<String, int> evs;
  final void Function(String stat, int value) onChanged;

  const _EvRow({
    required this.label,
    required this.stats,
    required this.evs,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 4),
        Row(
          children: stats.map((s) {
            final (statLabel, statKey) = s;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: _EvField(
                  label: statLabel,
                  value: evs[statKey] ?? 0,
                  onChanged: (v) => onChanged(statKey, v),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _EvField extends StatefulWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _EvField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_EvField> createState() => _EvFieldState();
}

class _EvFieldState extends State<_EvField> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(_EvField old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value && _ctrl.text != widget.value.toString()) {
      _ctrl.text = widget.value.toString();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      ),
      style: const TextStyle(fontSize: 13),
      onChanged: (v) {
        final n = int.tryParse(v) ?? 0;
        widget.onChanged(n.clamp(0, 252));
      },
    );
  }
}

// ─── テラスタイプ ──────────────────────────────────────

class _TeraTypeSelector extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const _TeraTypeSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('テラスタイプ', style: Theme.of(context).textTheme.labelMedium),
            if (value != null) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => onChanged(null),
                child: const Icon(Icons.close, size: 16),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: kTeraTypes.map((t) {
            final selected = value == t;
            return FilterChip(
              label: Text(t, style: const TextStyle(fontSize: 11)),
              selected: selected,
              onSelected: (_) => onChanged(selected ? null : t),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
              visualDensity: VisualDensity.compact,
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─── 計算ボタン ────────────────────────────────────────

class _CalcButton extends StatelessWidget {
  const _CalcButton();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalcProvider>();
    final state = provider.state;
    final canCalc = state.attacker != null && state.defender != null && state.move != null;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: canCalc ? provider.calculate : null,
        icon: const Icon(Icons.calculate),
        label: const Text('ダメージを計算'),
        style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
      ),
    );
  }
}

// ─── エラー表示 ────────────────────────────────────────

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.warning_amber, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}

// ─── 結果表示 ──────────────────────────────────────────

class _ResultCard extends StatelessWidget {
  final DamageResult result;

  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final koText = result.koCount == 1 ? '確定1発' : '確定${result.koCount}発';

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('結果', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              '${result.min} ~ ${result.max}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '${result.minPercent.toStringAsFixed(1)}% ~ ${result.maxPercent.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            Text(koText, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
