import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:internet_popup/internet_popup.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

import '../data/player_controller.dart';
import 'fragments/game_fragment.dart';
import 'fragments/load_game_widget.dart';
import 'utils/request_manager.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  var _progress = 0.0;
  var _isMain = true;
  late RequestManager _requestManager;
  late PlayerController _playerController;
  var isInit = false;
  final Lock lock = Lock();
  var isLoading = false;

  @override
  void initState() {
    InternetPopup().initialize(context: context);
    super.initState();

    initComponents();
    startLoading();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        if (isInit) {
          setState(() {
            _progress = 0.0;
          });
          if (!isLoading) {
            // startLoading();
          }
        }
      }
    });
  }

  void initComponents() async {
    await lock.synchronized(() async {
      if (!isInit) {
        await Firebase.initializeApp();
        var prefs = await SharedPreferences.getInstance();
        _playerController = PlayerController(prefs);
        _requestManager = RequestManager(_playerController);
      }
      setState(() {
        isInit = true;
      });
      startLoading();
    });
  }

  Future startLoading() async {
    await lock.synchronized(() async {
      var isOldUser = await _playerController.getPlayer();
      if (isOldUser) {
        setState(() {
          _goStartScreen(isOld: true);
        });
      } else {
        var link = await _playerController.getLink();
        if (link != null) {
          _runGame(link);
        } else {
          var isOpened = await _requestManager.isOpen();
          if (isOpened) {
            isLoading = true;
            await _requestManager.initFacebook();
            await _requestManager.initUUIds();

            var cloack = await _requestManager.requestToCloackIt();
            var status = await _requestManager.getOrganicStatus();

            var namingValue = await _requestManager.getNaming();
            var deepValue = await _requestManager.getDeepLink();
            print("NamingValue: $namingValue");
            print("DEEPVALUE: $deepValue");
            if (cloack != null) {
              var check = _requestManager.checkUser(cloack);
              if (check) {
                var keys = await _requestManager.getKeysList();
                nextLoad();
                if (keys != null) _requestManager.saveKeys(keys);
                nextLoad();
                var domain = await _requestManager.getLinkDomain();
                nextLoad();
                var params = await _requestManager.getParameters();
                nextLoad();

                if (params != null && domain != null) {
                  if (deepValue != null && deepValue.isNotEmpty) {
                    _requestManager.makeTrackLink(status, domain, params,
                        _requestManager.parseNaming(deepValue));
                  } else {
                    if (namingValue != null && namingValue.isNotEmpty) {
                      try {
                        _requestManager.makeTrackLink(status, domain, params,
                            _requestManager.parseNaming(namingValue));
                      } on Exception {
                        _requestManager.makeTrackLink(
                            true, domain, params, null);
                      }
                    } else {
                      if (status) {
                        _requestManager.makeTrackLink(
                            true, domain, params, null);
                      } else {
                        setState(() {
                          _goStartScreen();
                        });
                      }
                    }
                  }
                }
              }
            } else {
              setState(() {
                _goStartScreen();
              });
            }
          } else {
            setState(() {
              _goStartScreen();
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isMain == true
        ? Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                const Image(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/main_ui/start_bg.png'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: SizedBox(
                          height: 40,
                          child: LiquidLinearProgressIndicator(
                            value: _progress,
                            backgroundColor:
                                const Color.fromRGBO(16, 63, 117, 1),
                            valueColor: const AlwaysStoppedAnimation(
                                Color.fromARGB(251, 166, 41, 1)),
                            direction: Axis.horizontal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : const LoadGameWidget();
  }

  void nextLoad() {
    if (!isLoading) {
      setState(() {
        _progress += 0.25;
      });
    }
  }

  void _runGame(String link) {
    isLoading = true;
    runApp(GameFragment(link, _playerController));
  }

  void _goStartScreen({bool isOld = false}) {
    if (isOld) _requestManager.reject();
    setState(() {
      _isMain = false;
    });
  }
}
