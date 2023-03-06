import 'dart:developer';

import 'package:aedion/Modules/Compass/api/compass_api.dart';
import 'package:aedion/Modules/Compass/service/compass_service.dart';
import 'package:aedion/Services/location_service.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';
import 'package:location/location.dart';
import 'dart:math' as math;

class CompassState {
  final bool isSoundOn;
  final bool isHauFound;
  final double currentLatitude;
  final double currentLongitude;
  final double heartLatitude;
  final double heartLongitude;
  final double distance;
  final double initialTurns;

  CompassState({
    this.isHauFound = false,
    this.isSoundOn = true,
    this.currentLatitude = 28.1098,
    this.currentLongitude = 75.382761,
    this.heartLatitude = 28.4529,
    this.heartLongitude = 77.0399,
    this.distance = 200.0,
    this.initialTurns = 0.0,
  });

  CompassState copyWith({
    bool? isHauFound,
    bool? isSoundOn,
    double? currentLatitude,
    double? currentLongitude,
    double? heartLatitude,
    double? heartLongitude,
    double? distance,
    double? initialTurns,
  }) {
    return CompassState(
      isHauFound: isHauFound ?? this.isHauFound,
      isSoundOn: isSoundOn ?? this.isSoundOn,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      heartLatitude: heartLatitude ?? this.heartLatitude,
      heartLongitude: heartLongitude ?? this.heartLongitude,
      distance: distance ?? this.distance,
      initialTurns: initialTurns ?? this.initialTurns,
    );
  }
}

class CompassCubit extends Cubit<CompassState> {
  final player = AudioPlayer();
  CompassCubit() : super(CompassState());

  @override
  Future<void> close() {
    player.dispose();
    return super.close();
  }

  void onCompassInit() async {
    // get current location
    LocationData? currentLocation = await LocationService().getCurrentLocation();
    // get heart location
    GeoPoint? heartLocation = await CompassApi().getHeartLocation();
    // set current location
    if (currentLocation != null) {
      await CompassApi().setCurrentLocation(GeoPoint(currentLocation.latitude!, currentLocation.longitude!));
    }
    emit(state.copyWith(
      currentLatitude: currentLocation?.latitude,
      currentLongitude: currentLocation?.longitude,
      heartLatitude: heartLocation?.latitude,
      heartLongitude: heartLocation?.longitude,
    ));
    log('coordinates are : ${state.currentLatitude} ${state.currentLongitude} ${state.heartLatitude} ${state.heartLongitude}');
    calculateTurns();
    calculateDistance();
    playSound();
  }

  void setAlignmentDifference(double compassTurns) {
    double alignmentDifference = ((compassTurns - state.initialTurns).round() - (compassTurns - state.initialTurns)).abs();
    double x = double.parse(alignmentDifference.toStringAsFixed(2));
    setAlignedText(x);
    if (state.isSoundOn) {
      setHeartbeat(x);
    }
  }

  void setAlignedText(double alignmentDifference) {
    if (alignmentDifference >= 0 && alignmentDifference <= 0.01) {
      if (!state.isHauFound) {
        onHauFound();
      }
    } else {
      if (state.isHauFound) {
        onHauLost();
      }
    }
  }

  void playSound() async {
    final duration = await player.setAsset('assets/sounds/heartbeat.wav');
    await player.setLoopMode(LoopMode.one);
  }

  void setHeartbeat(double angleDifference) {
    if (angleDifference >= 0 && angleDifference <= 0.01) {
      player.play();
      player.setSpeed(1.5);
      // } else if (angleDifference > 0.01 && angleDifference <= 0.05) {
      //   player.play();
      //   player.setSpeed(2.5);
      // } else if (angleDifference > 0.05 && angleDifference <= 0.1) {
      //   player.play();
      //   player.setSpeed(2);
      // } else if (angleDifference > 0.1 && angleDifference <= 0.15) {
      //   player.play();
      //   player.setSpeed(1.8);
      // } else if (angleDifference > 0.15 && angleDifference <= 0.2) {
      //   player.play();
      //   player.setSpeed(1.5);
      // } else if (angleDifference > 0.2 && angleDifference <= 0.25) {
      //   player.play();
      //   player.setSpeed(1);
      // } else if (angleDifference > 0.25 && angleDifference <= 0.3) {
      //   player.play();
      //   player.setSpeed(0.8);
      // } else if (angleDifference > 0.3 && angleDifference <= 0.35) {
      //   player.play();
      //   player.setSpeed(0.8);
    } else {
      player.pause();
    }
  }

  void calculateDistance() {
    //  calculate distance between the coordinates
    double distance = CompassService().distanceBetweenCoordinates(
      state.currentLatitude,
      state.currentLongitude,
      state.heartLatitude,
      state.heartLongitude,
    );
    log('distance calculated is : $distance');
    emit(state.copyWith(distance: distance));
  }

  void calculateTurns() {
    // get initial turn of the love compass
    double angle = CompassService().angleBetweenCoordinates(
      state.currentLatitude,
      state.currentLongitude,
      state.heartLatitude,
      state.heartLongitude,
    );
    log('calculated turns are : ${angle / 360}');
    emit(state.copyWith(initialTurns: angle / 360));
  }

  void onHauFound() {
    emit(state.copyWith(isHauFound: true));
  }

  void onHauLost() {
    emit(state.copyWith(isHauFound: false));
  }

  void onSoundOn() {
    player.play();
    emit(state.copyWith(isSoundOn: true));
  }

  void onSoundOff() {
    player.stop();
    emit(state.copyWith(isSoundOn: false));
  }
}
