import 'package:flutter/services.dart';

class Consts {
  static var link =
      "https://b83k86z862.execute-api.eu-central-1.amazonaws.com/real";
  static var package = "com.firtorent.awarz";
  static var apskey = "yELrq3SM42JQkZEw8dHyHP";
  static const MethodChannel CHANNEL_AGENT = MethodChannel('get_agent');
  static const MethodChannel CHANNEL_FB = MethodChannel('get_fb');
  static const MethodChannel CHANNEL_UID = MethodChannel('get_uid');
  static const MethodChannel CHANNEL_NAMING = MethodChannel('get_naming');
  static const MethodChannel CHANNEL_DEEP = MethodChannel('get_deep');
}
