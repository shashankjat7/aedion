import 'dart:async';

import 'package:aedion/Modules/Tasks/SubModules/TaskDetails/services/clock.dart';
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

  void _onTaskStarted() {
    emit(TaskInProgress(task: state.task));
    _clockSubscription?.cancel();
    _clockSubscription = _clock
        .tick(
          ticks: state.task.timeSpent,
        )
        .listen((duration) => _onClockTicked(duration));
  }

  void _onTaskPaused() {
    if (state is TaskInProgress) {
      // update in firebase

      // if success, then pause the clock
      _clockSubscription?.pause();
      emit(TaskIdle(task: state.task));
    }
  }

  void _onClockTicked(int duration) {
    emit(TaskInProgress(task: state.task.copyWith(timeSpent: duration)));
  }

  void _onTaskCompleted() {
    //set to firebase
  }
}
