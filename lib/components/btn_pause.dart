import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';

class BtnPause extends SpriteComponent with Tappable {
  @override
  final Sprite sprite;
  final double screenX;

  BtnPause({required this.sprite, required this.screenX});

  @override
  FutureOr<void> onLoad() {
    size = Vector2(45, 45);
    position = Vector2(screenX - 95, 45);
    positionType = PositionType.viewport;

    return super.onLoad();
  }

  @override
  bool onTapDown(TapDownInfo info) {
    print("ON TAP DOWN");
    findGame()?.overlays.add('PauseMenu');
    findGame()?.paused = true;
    return true;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    print("ON TAP UP");
    return true;
  }
}
