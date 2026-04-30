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

int getPriorityValue(String priority) {
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
