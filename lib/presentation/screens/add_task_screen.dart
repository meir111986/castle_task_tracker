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

    if (!mounted) return;

    print(2);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Задача добавлена")));

    Navigator.pop(context);
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

              DropdownButtonFormField(
                value: priority,
                items: ["Low", "Medium", "High"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => priority = v!),
                decoration: InputDecoration(labelText: "Приоритет"),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: deadline,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );

                  if (picked != null) {
                    setState(() {
                      deadline = picked;
                    });
                  }
                },
                child: Text("Выбрать дедлайн"),
              ),

              SizedBox(height: 20),

              // ElevatedButton(
              //   onPressed: () async {
              //     print("CLICK TEST");

              //     await NotificationService.scheduleNotification(
              //       id: 999,
              //       title: 'TEST',
              //       body: 'Работает',
              //       scheduledDate: DateTime.now().add(
              //         const Duration(seconds: 5),
              //       ),
              //     );
              //   },
              //   child: const Text("TEST NOTIFICATION"),
              // ),
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
