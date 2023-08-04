import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../assets.dart';
import '../high_scores.dart';
import '../navigation/routes.dart';

class LoadGameWidget extends StatefulWidget {
  const LoadGameWidget({super.key});

  @override
  State<LoadGameWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<LoadGameWidget>
    with SingleTickerProviderStateMixin {
  var _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Image(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/start_bg.png'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: SizedBox(
                    height: 40,
                    child: Countdown(
                      seconds: 4,
                      build: (context, time) => LiquidLinearProgressIndicator(
                        value: _progress += 0.005,
                        backgroundColor: const Color.fromRGBO(16, 63, 117, 1),
                        valueColor: const AlwaysStoppedAnimation(
                            Color.fromARGB(251, 166, 41, 1)),
                        direction: Axis.horizontal,
                      ),
                      interval: const Duration(milliseconds: 18),
                      onFinished: () {
                        _runGame();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _runGame() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Flame.device.fullScreen();

    await HighScores.load();
    await Assets.load();
    runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Routes.routes,
      ),
    );
  }
}
