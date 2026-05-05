import 'package:task_tracker/domain/enums/category.dart';
import 'package:task_tracker/domain/enums/priority.dart';

class TaskEntity {
  final String title;
  final String description;
  final Priority priority;
  final Category category;
  final DateTime deadline;
  final bool isDone;
  final int? notificationId;

  const TaskEntity({
    required this.title,
    required this.description,
    required this.priority,
    required this.category,
    required this.deadline,
    required this.isDone,
    this.notificationId,
  });
}
