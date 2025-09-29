// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/data_service.dart';

// Import these when you create them
import 'project_management_screen.dart';
import 'task_management_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TimeEntry> timeEntries = [];
  List<Project> projects = [];
  List<Task> tasks = [];
  bool isGrouped = false;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      print('Loading data...');

      // Add a timeout to prevent indefinite loading
      final futures = await Future.wait([
        DataService.getTimeEntries(),
        DataService.getProjects(),
        DataService.getTasks(),
      ]).timeout(Duration(seconds: 10));

      print('Data loaded successfully');

      setState(() {
        timeEntries = futures[0] as List<TimeEntry>;
        projects = futures[1] as List<Project>;
        tasks = futures[2] as List<Task>;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load data: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(isGrouped ? Icons.list : Icons.group_work),
            onPressed: () {
              setState(() {
                isGrouped = !isGrouped;
              });
            },
          ),
          IconButton(icon: Icon(Icons.refresh), onPressed: loadData),
        ],
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Quick add dialog
          final result = await showDialog<Map<String, dynamic>>(
            context: context,
            builder: (context) {
              String time = '';
              return AlertDialog(
                title: Text('Quick Add Entry'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Hours (e.g., 2.5)',
                      ),
                      onChanged: (value) => time = value,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (time.isNotEmpty && double.tryParse(time) != null) {
                        Navigator.pop(context, {'time': double.parse(time)});
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );

          if (result != null) {
            // Add a dummy entry for screenshot purposes
            final entry = TimeEntry(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              totalTime: result['time'],
              projectId: '1', // Use first project
              taskId: '1', // Use first task
              notes: 'Sample entry for screenshots',
              date: DateTime.now(),
            );

            await DataService.addTimeEntry(entry);
            loadData();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Time Tracker',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.folder),
            title: Text('Projects'),
            onTap: () {
              Navigator.pop(context);
              // Uncomment when you create the screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectManagementScreen(),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Projects screen coming soon!')),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.task),
            title: Text('Tasks'),
            onTap: () {
              Navigator.pop(context);
              // Uncomment when you create the screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskManagementScreen()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tasks screen coming soon!')),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.add_circle),
            title: Text('Add Sample Data'),
            onTap: () async {
              await DataService.initializeSampleData();
              loadData();
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Sample data added!')));
            },
          ),
          ListTile(
            leading: Icon(Icons.clear_all),
            title: Text('Clear All Data'),
            onTap: () async {
              await DataService.clearAllData();
              loadData();
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('All data cleared!')));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading...'),
            SizedBox(height: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  isLoading = false;
                  errorMessage = 'Loading cancelled by user';
                });
              },
              child: Text('Cancel'),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 100, color: Colors.red[400]),
            SizedBox(height: 20),
            Text(
              'Error',
              style: TextStyle(
                fontSize: 24,
                color: Colors.red[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: loadData, child: Text('Retry')),
          ],
        ),
      );
    }

    if (timeEntries.isEmpty) {
      return _buildEmptyState();
    }

    // For now, just show a simple message
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Found ${timeEntries.length} time entries',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            'Found ${projects.length} projects',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text('Found ${tasks.length} tasks', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer_off, size: 100, color: Colors.grey[400]),
          SizedBox(height: 20),
          Text(
            'No time entries yet',
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Tap the + button to add your first time entry',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await DataService.initializeSampleData();
              loadData();
            },
            child: Text('Add Sample Data'),
          ),
        ],
      ),
    );
  }
}
