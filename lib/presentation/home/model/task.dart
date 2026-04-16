// lib/features/tasks/models/task.dart
class Task {
  final String title;
  final String subtitle;
  final DateTime completedAt;

  Task({
    required this.title,
    required this.subtitle,
    required this.completedAt,
  });
}
