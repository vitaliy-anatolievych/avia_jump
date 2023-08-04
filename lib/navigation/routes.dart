import 'dart:core';

import 'package:flutter/material.dart';

import '../ui/main_menu.dart';
import '../ui/my_game.dart';
import '../ui/rate_screen.dart';
import '../ui/rules_widget.dart';

enum Routes {
  main('/'),
  game('/game'),
  leaderboard('/leaderboard'),
  rules('/rules');

  final String route;

  const Routes(this.route);

  static Route routes(RouteSettings settings) {
    MaterialPageRoute _buildRoute(Widget widget) {
      return MaterialPageRoute(builder: (_) => widget, settings: settings);
    }

    final routeName = Routes.values.firstWhere((e) => e.route == settings.name);

    switch (routeName) {
      case Routes.main:
        return _buildRoute(const MainMenu());
      case Routes.game:
        return _buildRoute(const MyGameWidget());
      case Routes.leaderboard:
        return _buildRoute(const RateScreen());
      case Routes.rules:
        return _buildRoute(const RulesWidget());
      default:
        throw Exception('Route does not exists');
    }
  }
}

extension BuildContextExtension on BuildContext {
  void pushAndRemoveUntil(Routes route) {
    Navigator.pushNamedAndRemoveUntil(this, route.route, (route) => false);
  }

  void push(Routes route) {
    Navigator.pushNamed(this, route.route);
  }
}
