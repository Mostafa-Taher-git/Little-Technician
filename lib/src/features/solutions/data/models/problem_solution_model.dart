class ProblemSolution {
  final String problem;
  final String category;
  final List<String> steps;
  final String? symptoms;
  final String? cause;
  final String? estimatedTime;
  final int difficulty;

  ProblemSolution({
    required this.problem,
    required this.category,
    required this.steps,
    this.symptoms,
    this.cause,
    this.estimatedTime,
    this.difficulty = 1,
  });
}
