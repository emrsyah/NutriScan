class MealInfo {
  final List<String> labels;

  MealInfo({required this.labels});

  factory MealInfo.fromMap(Map<String, dynamic> map) {
    return MealInfo(
      labels: List<String>.from(map['labels'] as List<dynamic>? ?? []),
    );
  }
}
