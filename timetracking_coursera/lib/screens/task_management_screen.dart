// lib/screens/task_management_screen.dart
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/data_service.dart';

class TaskManagementScreen extends StatefulWidget {
  const TaskManagementScreen({super.key});

  @override
  _TaskManagementScreenState createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  List<Task> tasks = [];
  List<Project> projects = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final tasksList = await DataService.getTasks();
    final projectsList = await DataService.getProjects();
    setState(() {
      tasks = tasksList;
      projects = projectsList;
      isLoading = false;
    });
  }

  Project? getProjectById(String id) {
    try {
      return projects.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(),
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 100, color: Colors.grey[400]),
            SizedBox(height: 20),
            Text(
              'No tasks yet',
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Tap the + button to add your first task',
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final project = getProjectById(task.projectId);

        return Card(
          margin: EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange,
              child: Icon(Icons.task, color: Colors.white),
            ),
            title: Text(
              task.name,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.description),
                SizedBox(height: 4),
                Text(
                  'Project: ${project?.name ?? "Unknown"}',
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            isThreeLine: true,
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  _showEditTaskDialog(task);
                } else if (value == 'delete') {
                  _showDeleteConfirmation(task);
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _showAddTaskDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    Project? selectedProject;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add New Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Task Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // TextField(
                  //   controller: descriptionController,
                  //   decoration: InputDecoration(
                  //     labelText: 'Description',
                  //     border: OutlineInputBorder(),
                  //   ),
                  //   maxLines: 2,
                  // ),
                  // SizedBox(height: 16),
                  // DropdownButtonFormField<Project>(
                  //   initialValue: selectedProject,
                  //   decoration: InputDecoration(
                  //     labelText: 'Project',
                  //     border: OutlineInputBorder(),
                  //   ),
                  //   items: projects.map((Project project) {
                  //     return DropdownMenuItem<Project>(
                  //       value: project,
                  //       child: Text(project.name),
                  //     );
                  //   }).toList(),
                  //   onChanged: (Project? newProject) {
                  //     setState(() {
                  //       selectedProject = newProject;
                  //     });
                  //   },
                  // ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isNotEmpty &&
                        selectedProject != null) {
                      final task = Task(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: nameController.text,
                        description: descriptionController.text,
                        projectId: selectedProject.id,
                      );

                      await DataService.addTask(task);
                      Navigator.of(context).pop();
                      loadData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Task added successfully')),
                      );
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditTaskDialog(Task task) {
    final nameController = TextEditingController(text: task.name);
    final descriptionController = TextEditingController(text: task.description);
    Project? selectedProject = getProjectById(task.projectId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Task Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<Project>(
                    initialValue: selectedProject,
                    decoration: InputDecoration(
                      labelText: 'Project',
                      border: OutlineInputBorder(),
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
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isNotEmpty &&
                        selectedProject != null) {
                      final updatedTask = Task(
                        id: task.id,
                        name: nameController.text,
                        description: descriptionController.text,
                        projectId: selectedProject!.id,
                      );

                      // Update task in list
                      final taskIndex = tasks.indexWhere(
                        (t) => t.id == task.id,
                      );
                      tasks[taskIndex] = updatedTask;
                      await DataService.saveTasks(tasks);

                      Navigator.of(context).pop();
                      loadData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Task updated successfully')),
                      );
                    }
                  },
                  child: Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete "${task.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                tasks.removeWhere((t) => t.id == task.id);
                await DataService.saveTasks(tasks);

                Navigator.of(context).pop();
                loadData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Task deleted successfully')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
