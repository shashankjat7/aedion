import 'package:bloc/bloc.dart';

class CompassCubit extends Cubit<bool> {
  CompassCubit() : super(false);

  void onHauFound() {
    emit(true);
  }

  void onHauLost() {
    emit(false);
  }
}
