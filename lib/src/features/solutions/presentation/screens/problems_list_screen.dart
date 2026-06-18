import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/services/rule_engine.dart';
import 'package:littletech/src/core/widgets/app_widgets.dart';
import 'solution_detail_screen.dart';

class ProblemsListScreen extends StatelessWidget {
  final CategoryData category;
  const ProblemsListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: Text('${category.name} Solutions'),
      ),
      body: Column(
        children: [
          // Category header
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: scheme.outline),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(category.icon, color: scheme.onSurface, size: 28),
                ),
                const Gap(16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: scheme.onSurface)),
                    Text('${category.problems.length} common problems', style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.6), fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          // Problem list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: category.problems.length,
              separatorBuilder: (_, __) => const Gap(10),
              itemBuilder: (context, index) {
                return ProblemTile(
                  title: category.problems[index],
                  scheme: scheme,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SolutionDetailScreen(
                        problemName: category.problems[index],
                        categoryName: category.name,
                      ),
                    ),
                  ),
                ).animate(delay: Duration(milliseconds: 60 * index)).fadeIn().slideX(begin: 0.05);
              },
            ),
          ),
          const Gap(20),
        ],
      ),
    );
  }
}
