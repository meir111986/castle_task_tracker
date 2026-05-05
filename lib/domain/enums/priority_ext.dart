import 'package:task_tracker/domain/enums/priority.dart';

extension PriorityExt on Priority {
  String get priorityRu {
    switch (this) {
      case Priority.high:
        return "Высокий";
      case Priority.medium:
        return "Средний";
      case Priority.low:
        return "Низкий";
    }
  }

  int get weight {
    switch (this) {
      case Priority.high:
        return 3;
      case Priority.medium:
        return 2;
      case Priority.low:
        return 1;
    }
  }
}
