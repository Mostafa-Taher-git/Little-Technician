import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:littletech/src/core/services/rule_engine.dart';
import 'package:littletech/src/core/widgets/app_widgets.dart';
import 'problems_list_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${RuleEngine.categories.length} categories',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: scheme.onSurface.withValues(alpha: 0.6)),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: RuleEngine.categories.length,
          itemBuilder: (context, index) {
            final cat = RuleEngine.categories[index];
            return CategoryCard(
              title: cat.name,
              icon: cat.icon,
              scheme: scheme,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProblemsListScreen(category: cat),
                ),
              ),
            ).animate(delay: Duration(milliseconds: 50 * index)).fadeIn().scale(begin: const Offset(0.9, 0.9));
          },
        ),
      ),
    );
  }
}
