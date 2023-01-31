import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

abstract class RecordState {}

class InitialState extends RecordState {}

class ReadyState extends RecordState {
  String recordedText;
  ReadyState({required this.recordedText});
}

class ListeningState extends RecordState {
  String currentText = '';
  ListeningState({required this.currentText});

  String getCurrentText() => currentText;
}

class RecordedTextCubit extends Cubit<RecordState> {
  RecordedTextCubit() : super(InitialState());
  stt.SpeechToText speech = stt.SpeechToText();
  bool isAvailable = false;
  String finalText = '';
  String firstText = '';

  @override
  Future<void> close() {
    speech.cancel();
    return super.close();
  }

  void initializeSpeechToTextEngine() async {
    log('initializing the speech engine');
    bool available = await speech.initialize(
      onStatus: onSpeechStatusChanges,
      onError: onSpeechError,
    );
    if (available) {
      emit(ReadyState(recordedText: ''));
      listen();
    }
  }

  void listen() {
    firstText = '';
    speech.listen(
      onResult: (SpeechRecognitionResult result) {
        firstText = result.recognizedWords;
        emit(ListeningState(currentText: result.recognizedWords));
        if (result.finalResult == true) {
          onRecordingComplete();
        }
      },
    );
  }

  void onRecordingComplete() {
    if (firstText != '') {
      finalText = finalText + firstText + '\n';
    }
    emit(ReadyState(recordedText: finalText));
  }

  void onSpeechStatusChanges(String status) {
    log('status of text to speech : $status');
  }

  void onSpeechError(SpeechRecognitionError error) {
    log('error in text to speech : $error');
  }

  void onSpeechResult(SpeechRecognitionResult result) {}
}
