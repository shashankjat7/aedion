import 'dart:developer';

import 'package:aedion/Modules/Tasks/api/tasks_api.dart';
import 'package:aedion/Modules/Tasks/models/task_model.dart';
import 'package:aedion/Modules/Tasks/service/background_clock_service.dart';
import 'package:aedion/Services/shared_preference_service.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  TaskListBloc() : super(TaskListState()) {
    on<TaskListFetch>(_fetchTaskList);
    on<TaskListTaskAdded>(_addTaskToList);
    on<TaskListUpdated>(_updateTask);
    on<TaskListAppClosed>(_onAppClosed);
  }

  Future<void> _fetchTaskList(TaskListFetch event, Emitter<TaskListState> emit) async {
    List<TaskModel> taskList = await TasksApi().fetchTaskList();
    emit(state.copyWith(taskList: taskList, status: TaskListStatus.loaded));
  }

  void _addTaskToList(TaskListTaskAdded event, Emitter<TaskListState> emit) async {
    List<TaskModel>? tasks = state.taskList;
    tasks.add(event.addedTask);
    emit(state.copyWith(taskList: tasks));
  }

  void _updateTask(TaskListUpdated event, Emitter<TaskListState> emit) {
    List<TaskModel>? tasks = state.taskList;
    tasks[event.index] = event.updateTask;
    emit(state.copyWith(taskList: tasks));
  }

  void _onAppClosed(TaskListAppClosed event, Emitter<TaskListState> emit) async {
    List<String> tempList = [];
    for (var i in state.taskList) {
      if (i.taskStatus == TaskStatus.inProgress.toString()) {
        tempList.add(i.string());
      }
    }
    SharedPreferenceService().setStringList('ongoing_tasks', tempList);

    for (var i in state.taskList) {
      if (i.taskStatus == TaskStatus.inProgress.toString()) {
        BackgroundClockService().callBackgroundClock(i);
        log('this task was in progress : ${i.taskTitle}');
      }
    }
  }

  void _onTaskStarted() {}
}
