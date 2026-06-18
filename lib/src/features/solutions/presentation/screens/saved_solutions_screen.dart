import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
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
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(title: const Text('Saved Solutions')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? EmptyState(
                  icon: Icons.bookmark_outline,
                  title: 'Nothing Saved Yet',
                  subtitle: 'Solutions you bookmark will appear here for quick access.',
                  scheme: scheme,
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const Gap(10),
                  itemBuilder: (context, i) {
                    final item = _items[i];
                    return Container(
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: scheme.outline),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: scheme.surface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.article_outlined, color: scheme.onSurface, size: 20),
                        ),
                        title: Text(item.problemTitle, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: scheme.onSurface)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.category, style: TextStyle(color: scheme.secondary, fontSize: 12, fontWeight: FontWeight.w500)),
                            Text(
                              'Saved ${_formatDate(item.savedAt)}',
                              style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.6), fontSize: 11),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_outline, color: scheme.error, size: 20),
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
