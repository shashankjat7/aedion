import 'dart:async';
import 'dart:developer';

import 'package:aedion/Modules/Tasks/SubModules/TaskDetails/services/clock.dart';
import 'package:aedion/Modules/Tasks/api/tasks_api.dart';
import 'package:aedion/Modules/Tasks/models/task_model.dart';
import 'package:bloc/bloc.dart';

abstract class TaskState {
  final TaskModel task;
  const TaskState({
    required this.task,
  });
}

class TaskIdle extends TaskState {
  const TaskIdle({required super.task});
}

class TaskInProgress extends TaskState {
  const TaskInProgress({required super.task});
}

class TaskCompleted extends TaskState {
  const TaskCompleted({required super.task});
}

class TaskDetailsCubit extends Cubit<TaskState> {
  final Clock _clock;
  StreamSubscription<int>? _clockSubscription;
  TaskDetailsCubit({
    required Clock clock,
    required TaskModel task,
  })  : _clock = clock,
        super(TaskIdle(task: task));

  @override
  Future<void> close() {
    _clockSubscription?.cancel();
    return super.close();
  }

  void onInit() {
    if (state.task.taskStatus == TaskStatus.inProgress.toString()) {
      onTaskStarted(true);
    }
  }

  void onTaskStarted(bool isAlreadyRunning) async {
    int startTime = state.task.timeSpent;
    if (isAlreadyRunning) {
      startTime = state.task.timeSpent + ((DateTime.now().millisecondsSinceEpoch ~/ 1000) - state.task.updatedAt);
    } else {
      //update in firebase
      bool isUpdateSuccess = await TasksApi().updateTaskOnFirebase(
        state.task.taskId,
        {
          'updated_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
          'status': TaskStatus.inProgress.toString(),
        },
      );
      if (!isUpdateSuccess) {
        return;
      }
    }
    emit(
      TaskInProgress(
        task: state.task.copyWith(taskStatus: TaskStatus.inProgress.toString()),
      ),
    );
    _clockSubscription?.cancel();
    _clockSubscription = _clock
        .tick(
          ticks: startTime,
        )
        .listen((duration) => _onClockTicked(duration));
  }

  void onTaskPaused() async {
    if (state is TaskInProgress) {
      // update in firebase

      bool isUpdateSuccess = await TasksApi().updateTaskOnFirebase(
        state.task.taskId,
        {
          'updated_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
          'status': TaskStatus.idle.toString(),
          'time_spent': state.task.timeSpent,
        },
      );
      if (!isUpdateSuccess) {
        return;
      }

      // if success, then pause the clock
      _clockSubscription?.pause();
      emit(
        TaskIdle(
          task: state.task.copyWith(taskStatus: TaskStatus.idle.toString()),
        ),
      );
    }
  }

  void _onClockTicked(int duration) {
    emit(TaskInProgress(task: state.task.copyWith(timeSpent: duration)));
  }

  void _onTaskCompleted() {
    //set to firebase
  }
}
