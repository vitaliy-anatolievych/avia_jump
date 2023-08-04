import 'package:flutter/material.dart';

import '../navigation/routes.dart';
import 'widgets/my_text.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Image(
            fit: BoxFit.fill,
            image: AssetImage('assets/main_ui/start_bg.png'),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20),
            alignment: Alignment.topCenter,
            child: const MyText(
              'AVIA JUMP\nADVENTURE',
              fontSize: 60,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 100,
                child: IconButton(
                  iconSize: 170.0,
                  onPressed: () {
                    context.pushAndRemoveUntil(Routes.game);
                  },
                  icon: Image.asset('assets/main_ui/btn_play.png'),
                ),
              ),
              SizedBox(
                height: 100,
                child: IconButton(
                  iconSize: 170.0,
                  onPressed: () {
                    context.push(Routes.leaderboard);
                  },
                  icon: Image.asset('assets/main_ui/btn_rate.png'),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  iconSize: 70.0,
                  onPressed: () {
                    context.push(Routes.rules);
                  },
                  icon: Image.asset('assets/main_ui/btn_info.png'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
