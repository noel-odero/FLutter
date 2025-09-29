// lib/screens/add_entry_screen.dart
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/data_service.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  _AddEntryScreenState createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _timeController = TextEditingController();
  final _notesController = TextEditingController();

  List<Project> projects = [];
  List<Task> tasks = [];
  List<Task> availableTasks = [];

  Project? selectedProject;
  Task? selectedTask;
  DateTime selectedDate = DateTime.now();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final projectsList = await DataService.getProjects();
      final tasksList = await DataService.getTasks();

      setState(() {
        projects = projectsList;
        tasks = tasksList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
    }
  }

  void updateAvailableTasks() {
    if (selectedProject != null) {
      setState(() {
        availableTasks = tasks
            .where((task) => task.projectId == selectedProject!.id)
            .toList();
        // Reset selected task if it's not available for the new project
        if (selectedTask != null &&
            !availableTasks.any((t) => t.id == selectedTask!.id)) {
          selectedTask = null;
        }
      });
    } else {
      setState(() {
        availableTasks = [];
        selectedTask = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Time Entry'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Total Time Field
            TextFormField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: 'Total Time (hours)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.timer),
                hintText: 'e.g., 2.5',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter total time';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Project Dropdown
            DropdownButtonFormField<Project>(
              initialValue: selectedProject,
              decoration: InputDecoration(
                labelText: 'Project',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.folder),
              ),
              items: projects.map((Project project) {
                return DropdownMenuItem<Project>(
                  value: project,
                  child: Text(project.name),
                );
              }).toList(),
              onChanged: (Project? newProject) {
                setState(() {
                  selectedProject = newProject;
                });
                updateAvailableTasks();
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a project';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Task Dropdown
            DropdownButtonFormField<Task>(
              initialValue: selectedTask,
              decoration: InputDecoration(
                labelText: 'Task',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.task),
              ),
              items: availableTasks.map((Task task) {
                return DropdownMenuItem<Task>(
                  value: task,
                  child: Text(task.name),
                );
              }).toList(),
              onChanged: (Task? newTask) {
                setState(() {
                  selectedTask = newTask;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a task';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Notes Field
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes),
                hintText: 'Optional notes about this time entry',
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),

            // Date Picker
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.calendar_today),
              title: Text('Date'),
              subtitle: Text(
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null && picked != selectedDate) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
            ),
            SizedBox(height: 32),

            // Submit Button
            ElevatedButton(
              onPressed: _submitEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('Add Time Entry', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitEntry() async {
    if (_formKey.currentState!.validate()) {
      try {
        final timeEntry = TimeEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          totalTime: double.parse(_timeController.text),
          projectId: selectedProject!.id,
          taskId: selectedTask!.id,
          notes: _notesController.text,
          date: selectedDate,
        );

        await DataService.addTimeEntry(timeEntry);

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Time entry added successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding entry: $e')));
      }
    }
  }

  @override
  void dispose() {
    _timeController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
