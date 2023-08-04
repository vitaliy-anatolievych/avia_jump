import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import '../ui/widgets/my_text.dart';

import '../assets.dart';
import '../high_scores.dart';

class RateScreen extends StatelessWidget {
  const RateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = MediaQuery.of(context).size.height * .055;
    return Scaffold(
      body: Center(
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/main_ui/standart_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      iconSize: 50,
                      icon: SpriteWidget(
                        sprite: Assets.buttonBack,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                const MyText(
                  'Best Scores',
                  fontSize: 42,
                ),
                SizedBox(height: spacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                    ),
                    Image.asset('assets/main_ui/place_1.png'),
                    Container(
                      width: 60,
                    ),
                    MyText(
                      '${HighScores.highScores[0]}',
                      fontSize: 30,
                    ),
                  ],
                ),
                SizedBox(height: spacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                    ),
                    Image.asset('assets/main_ui/place_2.png'),
                    Container(
                      width: 60,
                    ),
                    MyText(
                      '${HighScores.highScores[1]}',
                      fontSize: 30,
                    ),
                  ],
                ),
                SizedBox(height: spacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                    ),
                    Image.asset('assets/main_ui/place_3.png'),
                    Container(
                      width: 60,
                    ),
                    MyText(
                      '${HighScores.highScores[2]}',
                      fontSize: 30,
                    ),
                  ],
                ),
                SizedBox(height: spacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                    ),
                    Image.asset('assets/main_ui/place_4.png'),
                    Container(
                      width: 60,
                    ),
                    MyText(
                      '${HighScores.highScores[3]}',
                      fontSize: 30,
                    ),
                  ],
                ),
                SizedBox(height: spacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                    ),
                    Image.asset('assets/main_ui/place_5.png'),
                    Container(
                      width: 80,
                    ),
                    MyText(
                      '${HighScores.highScores[4]}',
                      fontSize: 30,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
