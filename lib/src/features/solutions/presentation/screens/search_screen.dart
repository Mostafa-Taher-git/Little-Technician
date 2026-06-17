import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/services/rule_engine.dart';
import 'package:littletech/src/core/widgets/app_widgets.dart';
import 'solution_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  List<_SearchResult> _results = [];
  bool _searched = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _search(String query) {
    if (query.trim().isEmpty) {
      setState(() { _results = []; _searched = false; });
      return;
    }
    final q = query.toLowerCase().trim();
    final found = <_SearchResult>[];

    for (final cat in RuleEngine.categories) {
      for (final problem in cat.problems) {
        if (problem.toLowerCase().contains(q) || q.contains(problem.toLowerCase())) {
          found.add(_SearchResult(problem: problem, category: cat.name));
        }
      }
    }

    // Also search solution steps
    for (final cat in RuleEngine.categories) {
      for (final problem in cat.problems) {
        final sol = RuleEngine.solve(problem);
        if (sol != null && found.every((r) => r.problem != problem)) {
          for (final step in sol.steps) {
            if (step.toLowerCase().contains(q)) {
              found.add(_SearchResult(problem: problem, category: cat.name));
              break;
            }
          }
        }
      }
    }

    setState(() { _results = found; _searched = true; });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(title: const Text('Search Problems')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _ctrl,
              autofocus: true,
              onChanged: _search,
              decoration: InputDecoration(
                hintText: 'Search for a problem...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _ctrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () { _ctrl.clear(); _search(''); },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: _results.isEmpty
                ? _searched
                    ? EmptyState(
                        icon: Icons.search_off,
                        title: 'No Results',
                        subtitle: 'Try different keywords or browse categories from the home screen.',
                        scheme: scheme,
                      )
                    : EmptyState(
                        icon: Icons.search,
                        title: 'Search Solutions',
                        subtitle: 'Type keywords to find solutions for computer problems.',
                        scheme: scheme,
                      )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _results.length,
                    separatorBuilder: (_, __) => const Gap(8),
                    itemBuilder: (context, i) {
                      final r = _results[i];
                      return ProblemTile(
                        title: r.problem,
                        scheme: scheme,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SolutionDetailScreen(
                              problemName: r.problem,
                              categoryName: r.category,
                            ),
                          ),
                        ),
                      ).animate(delay: Duration(milliseconds: 40 * i)).fadeIn();
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SearchResult {
  final String problem;
  final String category;
  _SearchResult({required this.problem, required this.category});
}
