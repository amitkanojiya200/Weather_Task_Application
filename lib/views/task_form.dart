import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/providers/task_provider.dart';
import 'package:flutter_application_1/services/notification_service.dart';
import 'package:provider/provider.dart';

class TaskForm extends StatefulWidget {
  final TaskModel? existingTask;

  const TaskForm({super.key, this.existingTask});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _desc;
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    if (widget.existingTask != null) {
      _title = widget.existingTask!.title;
      _desc = widget.existingTask!.description;
      _dateTime = widget.existingTask!.dateTime;
    } else {
      _title = '';
      _desc = '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Add/Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              initialValue: _title,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required' : null,
              onSaved: (value) => _title = value!,
            ),
            TextFormField(
              initialValue: _desc,
              decoration: const InputDecoration(labelText: 'Description'),
              onSaved: (value) => _desc = value!,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text('Due: ${_dateTime.toString()}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _dateTime,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );

                if (date == null) return;

                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_dateTime),
                );

                if (time == null) return;

                final fullDateTime = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                );

                setState(() {
                  _dateTime = fullDateTime;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Save Task'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  final task = widget.existingTask;

                  if (task != null) {
                    task.title = _title;
                    task.description = _desc;
                    task.dateTime = _dateTime;
                    provider.updateTask(task);

                    await NotificationService.scheduleNotification(
                      id: task.key as int,
                      title: task.title,
                      body: task.description,
                      scheduledDate: task.dateTime,
                    );
                  } else {
                    final newTask = TaskModel(
                      title: _title,
                      description: _desc,
                      dateTime: _dateTime,
                    );
                    provider.addTask(newTask);

                    await Future.delayed(const Duration(milliseconds: 100));
                    final taskKey = newTask.key as int;

                    await NotificationService.scheduleNotification(
                      id: taskKey,
                      title: newTask.title,
                      body: newTask.description,
                      scheduledDate: newTask.dateTime,
                    );
                  }

                  if (!mounted) return;
                  Navigator.pop(context);
                }
              },
            )
          ]),
        ),
      ),
    );
  }
}
