import 'package:flutter/material.dart';
import 'package:task_tracker/presentation/widgets/calendar_view.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Календарь")),
      body: const CalendarView(),
    );
  }
}
