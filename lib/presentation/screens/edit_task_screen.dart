import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/data/models/task_model.dart';
import 'package:task_tracker/domain/enums/category.dart';
import 'package:task_tracker/domain/enums/category_ext.dart';
import 'package:task_tracker/domain/enums/priority.dart';
import 'package:task_tracker/domain/enums/priority_ext.dart';
import 'package:task_tracker/notification_service.dart';
import 'package:task_tracker/presentation/cubit/task_cubit.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskModel task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController descController;

  late Priority priority;
  late Category category;
  late DateTime deadline;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.task.title);
    descController = TextEditingController(text: widget.task.description);

    priority = widget.task.priority;
    category = widget.task.category;
    deadline = widget.task.deadline;
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

  Future<void> updateTask() async {
    if (!formKey.currentState!.validate()) return;

    if (widget.task.key is int) {
      await NotificationService.cancelNotification(widget.task.key as int);
    }

    widget.task.title = titleController.text.trim();
    widget.task.description = descController.text.trim();
    widget.task.priority = priority;
    widget.task.category = category;
    widget.task.deadline = deadline;

    context.read<TaskCubit>().updateTask(widget.task);

    // ставим новое уведомление
    await NotificationService.scheduleNotification(
      id: widget.task.key ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Task Reminder',
      body: widget.task.title,
      scheduledDate: deadline,
    );

    if (!mounted) return;

    Navigator.pop(context);
    Navigator.pop(context);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Задача обновлена")));
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Изменить задачу")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Название",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Введите название";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: "Описание",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<Priority>(
                value: priority,
                decoration: InputDecoration(
                  labelText: "Приоритет",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: Priority.values
                    .map(
                      (e) =>
                          DropdownMenuItem(value: e, child: Text(e.priorityRu)),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => priority = v);
                  }
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<Category>(
                value: category,
                decoration: InputDecoration(
                  labelText: "Категория",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: Category.values
                    .map(
                      (e) =>
                          DropdownMenuItem(value: e, child: Text(e.categoryRu)),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => category = v);
                  }
                },
              ),

              const SizedBox(height: 16),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text("Дедлайн"),
                  subtitle: Text("${deadline.toLocal()}".split('.')[0]),
                  trailing: const Icon(Icons.edit),
                  onTap: pickDateTime,
                ),
              ),

              const SizedBox(height: 12),

              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: updateTask,
                icon: const Icon(Icons.save),
                label: const Text("Сохранить изменения"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
