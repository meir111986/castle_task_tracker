import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_tracker/presentation/cubit/task_cubit.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskCubit>().state;

    final selectedTasks = tasks.where((task) {
      return task.deadline.day == selectedDay.day &&
          task.deadline.month == selectedDay.month &&
          task.deadline.year == selectedDay.year;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Календарь")),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2100),
            focusedDay: selectedDay,
            selectedDayPredicate: (day) => isSameDay(day, selectedDay),
            onDaySelected: (selected, _) {
              setState(() {
                selectedDay = selected;
              });
            },
          ),

          Expanded(
            child: ListView(
              children: selectedTasks.map((task) {
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.priority),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
