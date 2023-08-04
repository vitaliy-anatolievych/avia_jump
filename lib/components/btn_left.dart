import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../objects/hero.dart';

class BtnLeft extends SpriteComponent with Tappable {
  @override
  final Sprite sprite;

  final double screenY;
  final MyHero hero;

  BtnLeft({required this.sprite, required this.screenY, required this.hero});

  @override
  FutureOr<void> onLoad() {
    size = Vector2(80, 50);
    print("$screenY");
    position = Vector2(20, screenY - ((screenY / 10) * 3));
    positionType = PositionType.viewport;

    return super.onLoad();
  }

  @override
  bool onTapDown(TapDownInfo info) {
    hero.accelerationX = -1;
    return super.onTapDown(info);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    hero.accelerationX = 0;
    return super.onTapUp(info);
  }
}