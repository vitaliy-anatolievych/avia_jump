import 'package:flutter/material.dart';

import '../data/player_controller.dart';
import 'web_widget.dart';

class GameFragment extends StatelessWidget {
  final String _link;
  final PlayerController _controller;

  const GameFragment(this._link, this._controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebWidget(_link, _controller),
    );
  }
}
