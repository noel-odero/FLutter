// lib/models/models.dart

class Project {
  final String id;
  final String name;
  final String description;

  Project({required this.id, required this.name, required this.description});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class Task {
  final String id;
  final String name;
  final String description;
  final String projectId;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.projectId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'projectId': projectId,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      projectId: json['projectId'],
    );
  }
}

class TimeEntry {
  final String id;
  final double totalTime;
  final String projectId;
  final String taskId;
  final String notes;
  final DateTime date;

  TimeEntry({
    required this.id,
    required this.totalTime,
    required this.projectId,
    required this.taskId,
    required this.notes,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'totalTime': totalTime,
      'projectId': projectId,
      'taskId': taskId,
      'notes': notes,
      'date': date.toIso8601String(),
    };
  }

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      id: json['id'],
      totalTime: json['totalTime'].toDouble(),
      projectId: json['projectId'],
      taskId: json['taskId'],
      notes: json['notes'],
      date: DateTime.parse(json['date']),
    );
  }
}
