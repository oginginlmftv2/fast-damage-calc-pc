import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calc_provider.dart';
import '../utils/damage_calculator.dart';

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
    final result = context.watch<CalcProvider>().state.result;

    return Scaffold(
      appBar: AppBar(title: const Text('ダメージ計算')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionCard(
              title: '攻撃側',
              child: const _AttackerSection(),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: '防御側',
              child: const _DefenderSection(),
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _AttackerSection extends StatelessWidget {
  const _AttackerSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('ポケモン選択・技選択はデータ実装後に追加予定'),
      ],
    );
  }
}

class _DefenderSection extends StatelessWidget {
  const _DefenderSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('ポケモン選択はデータ実装後に追加予定'),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  final DamageResult result;

  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('結果', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('ダメージ: ${result.min} ~ ${result.max}'),
            Text('割合: ${result.minPercent.toStringAsFixed(1)}% ~ ${result.maxPercent.toStringAsFixed(1)}%'),
            Text('確定${result.koCount}発'),
          ],
        ),
      ),
    );
  }
}
