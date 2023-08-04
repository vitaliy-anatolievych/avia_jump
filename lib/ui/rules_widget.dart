import 'package:flutter/material.dart';

import 'widgets/my_text.dart';

class RulesWidget extends StatelessWidget {
  const RulesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/main_ui/standart_bg.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 0,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Image.asset(
                    'assets/main_ui/btn_back.png',
                  ),
                  iconSize: 50,
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blueAccent),
                    color: const Color.fromRGBO(0, 0, 0, 0.3),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: MyText(('You need to move up and collect coins.\nYou can move left and right with the buttons, and shoot when you have ammo.\nPick up a shield to protect yourself and a jetpack to gain an advantage.')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
