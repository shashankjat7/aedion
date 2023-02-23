import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskStatus {
  idle,
  inProgress,
  completed,
}

class TaskModel {
  final String taskId;
  final String taskTitle;
  final String userId;
  final String taskDescription;
  final int createdAt;
  final int updatedAt;
  final String taskStatus; //Task status
  final int timeSpent; //seconds

  TaskModel({
    required this.taskId,
    required this.taskTitle,
    required this.userId,
    required this.taskDescription,
    required this.createdAt,
    required this.updatedAt,
    required this.taskStatus,
    required this.timeSpent,
  });

  factory TaskModel.fromJson(Map<dynamic, dynamic> data) {
    return TaskModel(
      taskId: data['task_id'],
      taskTitle: data['title'],
      taskDescription: data['description'],
      createdAt: data['created_at'],
      updatedAt: data['updated_at'],
      taskStatus: data['status'],
      timeSpent: data['time_spent'],
      userId: data['user_id'],
    );
  }

  factory TaskModel.fromFirebase(DocumentSnapshot snapshot) {
    return TaskModel(
      taskId: snapshot.id,
      taskTitle: snapshot.get('title'),
      taskDescription: snapshot.get('description'),
      createdAt: snapshot.get('created_at'),
      updatedAt: snapshot.get('updated_at'),
      taskStatus: snapshot.get('status'),
      timeSpent: snapshot.get('time_spent'),
      userId: snapshot.get('user_id'),
    );
  }

  TaskModel copyWith({int? timeSpent, String? taskStatus}) {
    return TaskModel(
      taskId: this.taskId,
      taskTitle: this.taskTitle,
      taskDescription: this.taskDescription,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      taskStatus: taskStatus ?? this.taskStatus,
      timeSpent: timeSpent ?? this.timeSpent,
      userId: this.userId,
    );
  }
}
