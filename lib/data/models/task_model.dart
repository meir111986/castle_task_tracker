import 'package:hive/hive.dart';
import 'package:task_tracker/domain/entities/task_entity.dart';
import 'package:task_tracker/domain/enums/category.dart';
import 'package:task_tracker/domain/enums/priority.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  Priority priority;

  @HiveField(3)
  DateTime deadline;

  @HiveField(4)
  Category category;

  @HiveField(5)
  bool isDone;

  @HiveField(6)
  int? notificationId;

  @HiveField(7)
  DateTime createdAt;

  TaskModel({
    required this.title,
    required this.description,
    required this.priority,
    required this.deadline,
    required this.category,
    this.isDone = false,
    this.notificationId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  TaskEntity toEntity() {
    return TaskEntity(
      title: title,
      description: description,
      priority: priority,
      category: category,
      deadline: deadline,
      isDone: isDone,
      notificationId: notificationId,
    );
  }

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      title: entity.title,
      description: entity.description,
      priority: entity.priority,
      category: entity.category,
      deadline: entity.deadline,
      isDone: entity.isDone,
      notificationId: entity.notificationId,
    );
  }

  String get priorityRu {
    switch (priority) {
      case Priority.high:
        return "Высокий";
      case Priority.medium:
        return "Средний";
      case Priority.low:
        return "Низкий";
    }
  }

  String get categoryRu {
    switch (category) {
      case Category.work:
        return "Работа";
      case Category.personal:
        return "Личное";
    }
  }

  int get priorityWeight {
    switch (priority) {
      case Priority.high:
        return 3;
      case Priority.medium:
        return 2;
      case Priority.low:
        return 1;
    }
  }

  String get formattedDate {
    return "${deadline.day.toString().padLeft(2, '0')}."
        "${deadline.month.toString().padLeft(2, '0')}."
        "${deadline.year} "
        "${deadline.hour.toString().padLeft(2, '0')}:"
        "${deadline.minute.toString().padLeft(2, '0')}";
  }

  String get createdAtFormatted {
    return "${createdAt.day.toString().padLeft(2, '0')}."
        "${createdAt.month.toString().padLeft(2, '0')}."
        "${createdAt.year} "
        "${createdAt.hour.toString().padLeft(2, '0')}:"
        "${createdAt.minute.toString().padLeft(2, '0')}";
  }
}
