import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:aedion/Constants/custom_colors.dart';
import 'package:aedion/Constants/route_names.dart';
import 'package:aedion/Helpers/seconds_to_time.dart';
import 'package:aedion/Modules/Tasks/SubModules/TaskDetails/cubits/task_details_cubit.dart';
import 'package:aedion/Modules/Tasks/SubModules/TaskDetails/services/clock.dart';
import 'package:aedion/Modules/Tasks/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskDetailsPageView extends StatelessWidget {
  static const routeName = RouteNames.taskDetailsViewRouteName;
  final TaskModel task;
  const TaskDetailsPageView({required this.task, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskDetailsCubit(clock: Clock(), task: task)..onInit(),
      child: const TaskDetailsPage(),
    );
  }
}

class TaskDetailsPage extends StatelessWidget {
  const TaskDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.yellowish,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: CustomColors.yellowish,
          elevation: 0,
          titleSpacing: 0,
          centerTitle: true,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: GestureDetector(
              onTap: () {
                log('back button was tapped');
                Navigator.pop(context, context.read<TaskDetailsCubit>().state.task);
              },
              child: const Icon(
                Icons.expand_circle_down,
                color: CustomColors.blackish,
                size: 50,
              ),
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Icon(
                Icons.pending,
                color: CustomColors.blackish,
                size: 50,
              ),
            ),
          ],
        ),
      ),
      bottomSheet: const _StatusChangeButton(),
      body: BlocBuilder<TaskDetailsCubit, TaskState>(builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 100),
          children: [
            const SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.blackish),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
                child: Text(
                  state.task.taskStatus.split('.').last.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.blackish,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              state.task.taskTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 60,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time Spent',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      SecondsToTime().convertToTime(state.task.timeSpent),
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(state.task.updatedAt * 1000)),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Created By',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CachedNetworkImage(
                      imageUrl: '${FirebaseAuth.instance.currentUser!.photoURL}',
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                      ),
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Additional Description',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.4),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              state.task.taskDescription,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Created At',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.4),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(state.task.createdAt * 1000)),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _StatusChangeButton extends StatelessWidget {
  const _StatusChangeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskDetailsCubit, TaskState>(builder: (context, state) {
      return Material(
        color: CustomColors.yellowish,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Material(
            color: CustomColors.blackish,
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(40)),
              splashColor: CustomColors.definitelyWhite,
              onTap: () {
                if (state is TaskIdle) {
                  context.read<TaskDetailsCubit>().onTaskStarted(false);
                } else if (state is TaskInProgress) {
                  context.read<TaskDetailsCubit>().onTaskPaused();
                }
              },
              child: Container(
                height: 70,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.check_circle,
                        color: CustomColors.definitelyWhite,
                        size: 70,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          state is TaskIdle ? 'Start Task' : 'Pause Task',
                          style: const TextStyle(
                            color: CustomColors.definitelyWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 70,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
