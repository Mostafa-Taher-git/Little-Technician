class SavedSolution {
  final int? id;
  final String problemTitle;
  final String category;
  final List<String> steps;
  final DateTime savedAt;

  SavedSolution({
    this.id,
    required this.problemTitle,
    required this.category,
    required this.steps,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'problemTitle': problemTitle,
        'category': category,
        'steps': steps,
        'savedAt': savedAt.toIso8601String(),
      };

  factory SavedSolution.fromJson(Map<String, dynamic> json) => SavedSolution(
        id: json['id'] as int?,
        problemTitle: json['problemTitle'] as String,
        category: (json['category'] as String?) ?? 'General',
        steps: List<String>.from(json['steps'] as List),
        savedAt: DateTime.parse(json['savedAt'] as String),
      );
}
