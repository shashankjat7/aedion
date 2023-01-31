import 'dart:developer';

import 'package:aedion/Modules/Tasks/models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TasksApi {
  Future<List<TaskModel>> fetchTaskList() async {
    CollectionReference tasksRef = FirebaseFirestore.instance.collection('Tasks');
    List<TaskModel> tasks = [];
    try {
      QuerySnapshot fetchedTasks = await tasksRef.where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid).limit(10).get();
      tasks = fetchedTasks.docs.map((element) => TaskModel.fromFirebase(element)).toList();
      return tasks;
    } catch (e) {
      log('Error while fetching tasks from database : $e');
      return [];
    }
  }

  Future<DocumentReference?> postTaskToFirebase(Map<String, dynamic> newTask) async {
    CollectionReference tasks = FirebaseFirestore.instance.collection('Tasks');
    try {
      DocumentReference addedTask = await tasks.add(newTask);
      log('added task was ${addedTask.id}');
      return addedTask;
    } catch (e) {
      log('Error while posting task to database : $e');
      return null;
    }
  }
}
