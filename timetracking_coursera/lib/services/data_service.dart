// lib/services/data_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/models.dart';

class DataService {
  static const String _projectsKey = 'projects';
  static const String _tasksKey = 'tasks';
  static const String _timeEntriesKey = 'timeEntries';

  // Projects
  static Future<List<Project>> getProjects() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final projectsJson = prefs.getString(_projectsKey);

      if (projectsJson == null || projectsJson.isEmpty) return [];

      final List<dynamic> projectsList = json.decode(projectsJson);
      return projectsList.map((json) => Project.fromJson(json)).toList();
    } catch (e) {
      print('Error loading projects: $e');
      return [];
    }
  }

  static Future<void> saveProjects(List<Project> projects) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final projectsJson = json.encode(
        projects.map((p) => p.toJson()).toList(),
      );
      await prefs.setString(_projectsKey, projectsJson);
    } catch (e) {
      print('Error saving projects: $e');
    }
  }

  static Future<void> addProject(Project project) async {
    try {
      final projects = await getProjects();
      projects.add(project);
      await saveProjects(projects);
    } catch (e) {
      print('Error adding project: $e');
    }
  }

  // Tasks
  static Future<List<Task>> getTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getString(_tasksKey);

      if (tasksJson == null || tasksJson.isEmpty) return [];

      final List<dynamic> tasksList = json.decode(tasksJson);
      return tasksList.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      print('Error loading tasks: $e');
      return [];
    }
  }

  static Future<void> saveTasks(List<Task> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = json.encode(tasks.map((t) => t.toJson()).toList());
      await prefs.setString(_tasksKey, tasksJson);
    } catch (e) {
      print('Error saving tasks: $e');
    }
  }

  static Future<void> addTask(Task task) async {
    try {
      final tasks = await getTasks();
      tasks.add(task);
      await saveTasks(tasks);
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  // Time Entries
  static Future<List<TimeEntry>> getTimeEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final entriesJson = prefs.getString(_timeEntriesKey);

      if (entriesJson == null || entriesJson.isEmpty) return [];

      final List<dynamic> entriesList = json.decode(entriesJson);
      return entriesList.map((json) => TimeEntry.fromJson(json)).toList();
    } catch (e) {
      print('Error loading time entries: $e');
      return [];
    }
  }

  static Future<void> saveTimeEntries(List<TimeEntry> entries) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final entriesJson = json.encode(entries.map((e) => e.toJson()).toList());
      await prefs.setString(_timeEntriesKey, entriesJson);
    } catch (e) {
      print('Error saving time entries: $e');
    }
  }

  static Future<void> addTimeEntry(TimeEntry entry) async {
    try {
      final entries = await getTimeEntries();
      entries.add(entry);
      await saveTimeEntries(entries);
    } catch (e) {
      print('Error adding time entry: $e');
    }
  }

  static Future<void> deleteTimeEntry(String entryId) async {
    try {
      final entries = await getTimeEntries();
      entries.removeWhere((entry) => entry.id == entryId);
      await saveTimeEntries(entries);
    } catch (e) {
      print('Error deleting time entry: $e');
    }
  }

  // Clear all data (for screenshots)
  static Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_projectsKey);
      await prefs.remove(_tasksKey);
      await prefs.remove(_timeEntriesKey);
    } catch (e) {
      print('Error clearing data: $e');
    }
  }

  // Initialize with sample data for testing
  static Future<void> initializeSampleData() async {
    try {
      final projects = await getProjects();
      final tasks = await getTasks();

      if (projects.isEmpty) {
        // Add sample projects
        await addProject(
          Project(
            id: '1',
            name: 'Website Development',
            description: 'Building company website',
          ),
        );

        await addProject(
          Project(
            id: '2',
            name: 'Mobile App',
            description: 'iOS and Android app development',
          ),
        );
      }

      if (tasks.isEmpty) {
        // Add sample tasks
        await addTask(
          Task(
            id: '1',
            name: 'Design Homepage',
            description: 'Create mockup and design',
            projectId: '1',
          ),
        );

        await addTask(
          Task(
            id: '2',
            name: 'Setup Database',
            description: 'Configure backend database',
            projectId: '1',
          ),
        );
      }
    } catch (e) {
      print('Error initializing sample data: $e');
    }
  }
}
