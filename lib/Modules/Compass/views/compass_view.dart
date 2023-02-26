import 'dart:developer';

import 'package:aedion/Modules/Compass/cubits/compass_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smooth_compass/utils/src/compass_ui.dart';

class CompassPageView extends StatelessWidget {
  const CompassPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CompassCubit(),
      child: const CompassView(),
    );
  }
}

class CompassView extends StatefulWidget {
  const CompassView({
    Key? key,
  }) : super(key: key);

  @override
  _CompassViewState createState() => _CompassViewState();
}

class _CompassViewState extends State<CompassView> {
  double distance = 0;
  double turns = 0; // turn the compass initially to this angle to adjust pole

  void checkPermission() async {
    Permission _permission = Permission.location;
    if (await _permission.status.isDenied) {
      PermissionStatus x = await _permission.request();
      if (x == PermissionStatus.denied) {
        Navigator.pop(context);
      }
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = math.cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return double.parse((12742 * math.asin(math.sqrt(a))).toStringAsFixed(2));
  }

  double angleFromCoordinate(double lat1, double long1, double lat2, double long2) {
    double dLon = (long1 - long2);

    double y = math.sin(dLon) * math.cos(lat2);
    double x = math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    double brng = math.atan2(y, x);

    double degreeAngle = brng * 57.2958;
    degreeAngle = (degreeAngle + 360) % 360;
    setState(() {
      turns = degreeAngle / 360;
    });
    // brng = 360 - brng; // count degrees counter-clockwise - remove to make clockwise
    log('brng is $brng');

    return brng;
  }

  double angle = 0;

  final player = AudioPlayer();
  void playSound() async {
    final duration = await player.setAsset('assets/sounds/heartbeat.wav');
    await player.setLoopMode(LoopMode.one);
    // await player.setSpeed(1);
    // await player.play(); // Play while waiting for completion
    // await player.pause(); // Pause but remain ready to play
    // await player.seek(
    //   Duration(seconds: 10),
    // ); // Jump to the 10 second position
    // await player.stop();
  }

  double angleDifference = 0;

  void checkAlignment(double angleDifference) {
    // log('angle is : $angle');
    if (angleDifference >= 0 && angleDifference <= 0.01) {
      if (!context.read<CompassCubit>().state.isHauFound) {
        context.read<CompassCubit>().onHauFound();
      }
    } else {
      if (context.read<CompassCubit>().state.isHauFound) {
        context.read<CompassCubit>().onHauLost();
      }
    }
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

  void setAngleDifference(double compassTurns) {
    // log('compass turns: $compassTurns , angle is : $angle');
    angleDifference = ((compassTurns - turns).round() - (compassTurns - turns)).abs();
    // log('angle difference is : $angleDifference');

    double x = double.parse(angleDifference.toStringAsFixed(2));
    checkAlignment(x);
    if (context.read<CompassCubit>().state.isSoundOn) {
      setHeartbeat(x);
    }
  }

  void initiateData() {
    setState(() {
      angle = angleFromCoordinate(28.1098, 75.382761, 28.4529, 77.0399);
      distance = calculateDistance(28.1098, 75.382761, 28.4529, 77.0399);
      log('angle is : $angle');
    });
    playSound();
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
    initiateData();
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFA20913),
        appBar: AppBar(
          backgroundColor: Color(0xFFA20913),
          elevation: 0,
          actions: [
            BlocBuilder<CompassCubit, CompassState>(builder: (context, state) {
              return state.isSoundOn
                  ? IconButton(
                      onPressed: () {
                        player.stop();
                        context.read<CompassCubit>().onSoundOff();
                      },
                      icon: const Icon(Icons.volume_off),
                    )
                  : IconButton(
                      onPressed: () {
                        player.play();
                        context.read<CompassCubit>().onSoundOn();
                      },
                      icon: const Icon(Icons.volume_up),
                    );
            }),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: BlocBuilder<CompassCubit, CompassState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: state.isHauFound
                        ? Text(
                            "You found me baby \n I'm only $distance kms away",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : const Text(
                            'Listen to my heartbeat and find me',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  );
                },
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: SmoothCompass(
                  rotationSpeed: 200,
                  compassBuilder: (context, compassData, child) {
                    setAngleDifference(compassData!.data!.turns);
                    return child;
                  },
                  compassAsset: Center(
                    child: RotationTransition(
                      turns: AlwaysStoppedAnimation(turns),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/love_compass.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
