import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../objects/hero.dart';

class BtnFire extends SpriteComponent with Tappable {
  @override
  final Sprite sprite;

  final double screenX;
  final double screenY;
  final MyHero hero;

  BtnFire({required this.sprite, required this.screenX, required this.screenY, required this.hero});

  @override
  FutureOr<void> onLoad() {
    size = Vector2(50, 50);
    position = Vector2(screenX / 2 - 25, screenY - ((screenY / 10) * 3));
    positionType = PositionType.viewport;

    return super.onLoad();
  }

  @override
  bool onTapDown(TapDownInfo info) {
    hero.fireBullet();
    return super.onTapDown(info);
  }
}