import 'package:bloc/bloc.dart';

class CompassState {
  final bool isSoundOn;
  final bool isHauFound;

  CompassState({
    this.isHauFound = false,
    this.isSoundOn = true,
  });

  CompassState copyWith({
    bool? isHauFound,
    bool? isSoundOn,
  }) {
    return CompassState(
      isHauFound: isHauFound ?? this.isHauFound,
      isSoundOn: isSoundOn ?? this.isSoundOn,
    );
  }
}

class CompassCubit extends Cubit<CompassState> {
  CompassCubit() : super(CompassState());

  void onHauFound() {
    emit(state.copyWith(isHauFound: true));
  }

  void onHauLost() {
    emit(state.copyWith(isHauFound: false));
  }

  void onSoundOn() {
    emit(state.copyWith(isSoundOn: true));
  }

  void onSoundOff() {
    emit(state.copyWith(isSoundOn: false));
  }
}
