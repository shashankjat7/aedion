import 'dart:developer';

import 'package:aedion/Modules/Tasks/api/tasks_api.dart';
import 'package:aedion/Modules/Tasks/models/task_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'create_task_state.dart';

class CreateTaskCubit extends Cubit<CreateTaskState> {
  CreateTaskCubit() : super(const CreateTaskState());

  void onTitleChanged(String value) {
    emit(state.copyWith(title: value));
  }

  void onDescriptionChanged(String value) {
    emit(state.copyWith(description: value));
  }

  void onCreateButtonPressed() async {
    if (!state.isTitleValid() || !state.isDescriptionValid()) {
      log('Task details are invalid');
      return;
    }
    emit(state.copyWith(status: CreatedTaskStatus.postingInProgress));
    Map<String, dynamic> newTask = {
      'user_id': FirebaseAuth.instance.currentUser!.uid,
      'title': state.title,
      'description': state.description,
      'created_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'updated_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'status': TaskStatus.idle.toString(),
      'time_spent': 0,
    };
    DocumentReference? addedTask = await TasksApi().postTaskToFirebase(newTask);
    if (addedTask != null) {
      newTask['task_id'] = addedTask.id;
      TaskModel task = TaskModel.fromJson(newTask);
      emit(state.copyWith(createdTask: task, status: CreatedTaskStatus.postSuccess));
    } else {
      emit(state.copyWith(status: CreatedTaskStatus.postFailure));
    }
  }
}
