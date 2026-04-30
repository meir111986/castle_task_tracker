import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  String priority;

  @HiveField(3)
  DateTime deadline;

  @HiveField(4)
  String category;

  @HiveField(5)
  bool isDone;

  @HiveField(6)
  int? notificationId;

  TaskModel({
    required this.title,
    required this.description,
    required this.priority,
    required this.deadline,
    required this.category,
    this.isDone = false,
  });
}
