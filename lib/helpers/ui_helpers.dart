import 'package:flutter/material.dart';

Color getPriorityColor(String priority) {
  switch (priority) {
    case "High":
      return Colors.red;
    case "Medium":
      return Colors.orange;
    case "Low":
      return Colors.green;
    default:
      return Colors.grey;
  }
}

String getPriorityValue(String priority) {
  switch (priority) {
    case "High":
      return "Высокий";
    case "Medium":
      return "Средний";
    case "Low":
      return "Низкий";
    default:
      return priority;
  }
}

int getPriorityWeight(String priority) {
  switch (priority) {
    case "High":
      return 3;
    case "Medium":
      return 2;
    case "Low":
      return 1;
    default:
      return 0;
  }
}

String getCategory(String category) {
  switch (category) {
    case "All":
      return "Все";
    case "Work":
      return "Работа";
    case "Personal":
      return "Личное";
    default:
      return category;
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
