import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_tracker/data/models/task_model.dart';
import 'package:task_tracker/helpers/ui_helpers.dart';
import 'package:task_tracker/presentation/cubit/task_cubit.dart';
import 'package:task_tracker/presentation/screens/task_detail_screen.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  CalendarFormat calendarFormat = CalendarFormat.month;

  List getTasksForDay(List tasks, DateTime day) {
    return tasks.where((task) {
      return task.deadline.year == day.year &&
          task.deadline.month == day.month &&
          task.deadline.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, List>(
      builder: (context, tasks) {
        final dayTasks = getTasksForDay(tasks, selectedDay);

        return Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020),
              lastDay: DateTime.utc(2100),
              focusedDay: focusedDay,

              selectedDayPredicate: (day) => isSameDay(selectedDay, day),

              calendarFormat: calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  calendarFormat = format;
                });
              },

              onDaySelected: (selected, focused) {
                setState(() {
                  selectedDay = selected;
                  focusedDay = focused;
                });
              },

              eventLoader: (day) {
                return getTasksForDay(tasks, day);
              },

              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isEmpty) return null;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: events.take(3).map((e) {
                      final task = e as TaskModel;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: getPriorityColor(task.priority),
                          shape: BoxShape.circle,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: dayTasks.isEmpty
                  ? const Center(child: Text("Нет задач"))
                  : ListView.builder(
                      itemCount: dayTasks.length,
                      itemBuilder: (context, index) {
                        final task = dayTasks[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: getPriorityColor(task.priority),
                              child: Text(
                                task.priority[0],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(task.title),
                            subtitle: Text(
                              "${task.deadline.hour.toString().padLeft(2, '0')}:${task.deadline.minute.toString().padLeft(2, '0')}",
                            ),

                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TaskDetailScreen(task: task),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
