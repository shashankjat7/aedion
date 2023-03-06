import 'package:aedion/Modules/Compass/cubits/compass_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_compass/utils/src/compass_ui.dart';

class CompassPageView extends StatelessWidget {
  const CompassPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CompassCubit()..onCompassInit(),
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFA20913),
        appBar: AppBar(
          backgroundColor: const Color(0xFFA20913),
          elevation: 0,
          actions: [
            BlocBuilder<CompassCubit, CompassState>(builder: (context, state) {
              return state.isSoundOn
                  ? IconButton(
                      onPressed: () {
                        context.read<CompassCubit>().onSoundOff();
                      },
                      icon: const Icon(Icons.volume_off),
                    )
                  : IconButton(
                      onPressed: () {
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
                            "You found me baby \n I'm only ${state.distance} kms away",
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
                    context.read<CompassCubit>().setAlignmentDifference(compassData!.data!.turns);
                    // setAngleDifference(compassData!.data!.turns);
                    return child;
                  },
                  compassAsset: Center(
                    child: BlocBuilder<CompassCubit, CompassState>(
                      buildWhen: (previousState, state) {
                        if (previousState.initialTurns == state.initialTurns) {
                          return false;
                        }
                        return true;
                      },
                      builder: (context, state) {
                        return RotationTransition(
                          turns: AlwaysStoppedAnimation(state.initialTurns),
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/love_compass.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      },
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
