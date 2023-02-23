import 'dart:developer';

import 'package:aedion/Modules/HomeScreen/SubModules/RecordPage/cubits/recorded_text_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class RecordAudioView extends StatelessWidget {
  const RecordAudioView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecordedTextCubit(),
      child: BlocBuilder<RecordedTextCubit, RecordState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Record Audio'),
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.mic),
              onPressed: () {
                if (state is ReadyState) {
                  context.read<RecordedTextCubit>().listen();
                } else {
                  context.read<RecordedTextCubit>().initializeSpeechToTextEngine();
                }
              },
            ),
            body: SafeArea(
              child: Container(
                child: state is InitialState
                    ? const Text('')
                    : state is ReadyState
                        ? Text(
                            state.recordedText,
                            textAlign: TextAlign.left,
                          )
                        : state is ListeningState
                            ? Text(
                                state.currentText,
                                textAlign: TextAlign.left,
                              )
                            : Container(),
              ),
            ),
          );
        },
      ),
    );
  }
}
