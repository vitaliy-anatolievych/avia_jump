import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../objects/hero.dart';

class BtnRight extends SpriteComponent with Tappable {
  @override
  final Sprite sprite;

  final double screenX;
  final double screenY;
  final MyHero hero;

  BtnRight({required this.sprite, required this.screenX, required this.screenY, required this.hero});

  @override
  FutureOr<void> onLoad() {
    size = Vector2(80, 50);
    position = Vector2(screenX - 130, screenY - ((screenY / 10) * 3));
    positionType = PositionType.viewport;
    return super.onLoad();
  }

  @override
  bool onTapDown(TapDownInfo info) {
    hero.accelerationX = 1;
    return super.onTapDown(info);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    hero.accelerationX = 0;
    return super.onTapUp(info);
  }
}