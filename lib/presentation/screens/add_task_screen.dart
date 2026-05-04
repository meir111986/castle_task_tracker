import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/data/models/task_model.dart';
import 'package:task_tracker/notification_service.dart';
import 'package:task_tracker/presentation/cubit/task_cubit.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  String priority = "Low";
  String category = "Work";
  DateTime deadline = DateTime.now();

  final formKey = GlobalKey<FormState>();

  Future<void> saveTask() async {
    if (!formKey.currentState!.validate()) return;

    final task = TaskModel(
      title: titleController.text.trim(),
      description: descController.text.trim(),
      priority: priority,
      deadline: deadline,
      category: category,
    );

    context.read<TaskCubit>().addTask(task);

    // await NotificationService.showNow();

    await NotificationService.scheduleNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Task Reminder',
      body: titleController.text,
      scheduledDate: deadline,
      // scheduledDate: DateTime.now().add(const Duration(seconds: 10)),
    );

    if (!mounted) return;

    print(2);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Задача добавлена")));

    Navigator.pop(context);
  }

  Future<void> pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(deadline),
    );

    if (pickedTime == null) return;

    setState(() {
      deadline = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(deadline),
    );

    if (pickedTime != null) {
      setState(() {
        deadline = DateTime(
          deadline.year,
          deadline.month,
          deadline.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Добавить задачу")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Название"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Введите название" : null,
              ),
              TextFormField(
                controller: descController,
                decoration: InputDecoration(labelText: "Описание"),
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: priority,
                decoration: InputDecoration(
                  labelText: "Приоритет",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: ["Low", "Medium", "High"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => priority = v);
                  }
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: category,
                decoration: InputDecoration(
                  labelText: "Категория",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: ["Work", "Personal"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => category = v);
                  }
                },
              ),

              SizedBox(height: 20),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text("Дедлайн"),
                  subtitle: Text("${deadline.toLocal()}".split('.')[0]),
                  trailing: const Icon(Icons.edit),
                  onTap: pickDateTime,
                ),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  print("CLICK TEST");

                  await NotificationService.showNow();
                },
                child: const Text("TEST NOTIFICATION"),
              ),

              SizedBox(height: 20),

              ElevatedButton(onPressed: saveTask, child: Text("Сохранить")),
            ],
          ),
        ),
      ),
    );
  }
}
