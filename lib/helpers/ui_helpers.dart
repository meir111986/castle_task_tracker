import 'package:flutter/material.dart';
import 'package:task_tracker/domain/enums/priority.dart';

Color getPriorityColor(Priority priority) {
  switch (priority) {
    case Priority.high:
      return Colors.red;
    case Priority.medium:
      return Colors.orange;
    case Priority.low:
      return Colors.green;
  }
}

String getSort(String sort) {
  switch (sort) {
    case "None":
      return "Без сортировки";
    case "Priority":
      return "По приоритету";
    case "Date":
      return "По дате";
    default:
      return sort;
  }
}
