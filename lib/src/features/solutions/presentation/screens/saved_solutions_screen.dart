import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/constants/colors.dart';
import 'package:littletech/src/core/widgets/app_widgets.dart';
import 'package:littletech/src/features/solutions/data/models/saved_solution_model.dart';
import 'package:littletech/src/features/solutions/data/services/saved_solutions_service.dart';
import 'solution_detail_screen.dart';

class SavedSolutionsScreen extends StatefulWidget {
  const SavedSolutionsScreen({super.key});

  @override
  State<SavedSolutionsScreen> createState() => _SavedSolutionsScreenState();
}

class _SavedSolutionsScreenState extends State<SavedSolutionsScreen> {
  List<SavedSolution> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await SavedSolutionsService.getAll();
    if (mounted) setState(() { _items = list; _loading = false; });
  }

  Future<void> _delete(int id) async {
    await SavedSolutionsService.delete(id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Saved Solutions')),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _items.isEmpty
              ? const EmptyState(
                  icon: Icons.bookmark_outline,
                  title: 'Nothing Saved Yet',
                  subtitle: 'Solutions you bookmark will appear here for quick access.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const Gap(10),
                  itemBuilder: (context, i) {
                    final item = _items[i];
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.article_outlined, color: AppColors.primary, size: 20),
                        ),
                        title: Text(item.problemTitle, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.category, style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w500)),
                            Text(
                              'Saved ${_formatDate(item.savedAt)}',
                              style: const TextStyle(color: AppColors.onSurfaceMuted, fontSize: 11),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                          onPressed: () => _delete(item.id!),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SolutionDetailScreen(
                              problemName: item.problemTitle,
                              categoryName: item.category,
                            ),
                          ),
                        ),
                      ),
                    ).animate(delay: Duration(milliseconds: 50 * i)).fadeIn();
                  },
                ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day}/${d.month}/${d.year}';
  }
}
