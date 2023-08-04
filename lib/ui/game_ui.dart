import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../assets.dart';
import '../components/btn_fire.dart';
import '../components/btn_left.dart';
import '../components/btn_pause.dart';
import '../components/btn_right.dart';
import '../my_game.dart';
import '../objects/hero.dart';
import '../utils.dart';

final textPaint = TextPaint(
  style: const TextStyle(
    color: Colors.white,
    fontSize: 35,
    fontWeight: FontWeight.w800,
    fontFamily: 'DaveysDoodleface',
  ),
);

class GameUI extends PositionComponent with HasGameRef<MyGame> {
  final MyHero hero;

  GameUI({required this.hero});

  // Keep track of the number of bodies in the world.
  final totalBodies =
      TextComponent(position: Vector2(5, 895), textRenderer: textPaint);

  final totalScore = TextComponent(textRenderer: textPaint);

  final totalCoins = TextComponent(textRenderer: textPaint);

  final totalBullets = TextComponent(textRenderer: textPaint);

  final coin = SpriteComponent(sprite: Assets.coin, size: Vector2.all(25));
  final gun = SpriteComponent(sprite: Assets.gun, size: Vector2.all(35));

  // Keep track of the frames per second
  final fps =
      FpsTextComponent(position: Vector2(5, 870), textRenderer: textPaint);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    positionType = PositionType.viewport;
    position.y = isIOS ? 25 : 0;
    priority = 3;


    final btnPause = BtnPause(sprite: Assets.buttonPause, screenX: screenSize.x);
    final btnLeft = BtnLeft(sprite: Assets.btnLeft, screenY: screenSize.y, hero: hero);
    final btRight = BtnRight(sprite: Assets.btnRight, screenX: screenSize.x, screenY: screenSize.y, hero: hero);
    final btFire = BtnFire(sprite: Assets.btnFire, screenX: screenSize.x, screenY: screenSize.y, hero: hero);

    add(btFire);
    add(btRight);
    add(btnLeft);
    add(btnPause);
    add(coin);
    add(gun);
    add(fps);
    add(totalBodies);
    add(totalScore);
    add(totalCoins);
    add(totalBullets);
  }

  @override
  void update(double dt) {
    super.update(dt);

    totalBodies.text = 'Bodies: ${gameRef.world.bodies.length}';
    totalScore.text = 'Score ${gameRef.score}';
    totalCoins.text = 'x${gameRef.coins}';
    totalBullets.text = 'x${gameRef.bullets}';

    final posX = screenSize.x - totalCoins.size.x;
    totalCoins.position
      ..x = posX - 50
      ..y = 5;
    coin.position
      ..x = posX - 80
      ..y = 12;

    gun.position
      ..x = 5
      ..y = 12;
    totalBullets.position
      ..x = 40
      ..y = 8;

    totalScore.position
      ..x = screenSize.x / 2 - totalScore.size.x / 2
      ..y = 5;
  }
}
