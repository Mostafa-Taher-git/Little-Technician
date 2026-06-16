import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/constants/colors.dart';
import 'package:littletech/src/core/services/rule_engine.dart';
import 'package:littletech/src/core/widgets/app_widgets.dart';
import 'solution_detail_screen.dart';

class ProblemsListScreen extends StatelessWidget {
  final CategoryData category;
  const ProblemsListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(category.icon, color: AppColors.primary, size: 28),
                ),
                const Gap(16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                    Text('${category.problems.length} common problems', style: const TextStyle(color: AppColors.onSurfaceMuted, fontSize: 13)),
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
