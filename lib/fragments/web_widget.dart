import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:string_validator/string_validator.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:url_launcher/url_launcher.dart' hide launch;
import '../data/player_controller.dart';
import '../model/player_info.dart';

class WebWidget extends StatefulWidget {
  final String _link;
  final PlayerController _controller;
  const WebWidget(this._link, this._controller, {super.key});

  @override
  State<WebWidget> createState() => _WebWidgetState(_link, _controller);
}

class _WebWidgetState extends State<WebWidget> {
  final String _link;
  final PlayerController _controller;
  List<String>? _keys;
  late PlayerInfo _info;

  double _progress = 0;
  late InAppWebViewController _inAppWebViewController;

  _WebWidgetState(this._link, this._controller) {
    _keys = _controller.getKeys();
    _info = _controller.getInfo();
    _setUpView();
  }

  void _setUpView() {
    if (_info.isAnalysis) {
      _info.counter--;

      if (_info.counter == 0) {
        _info.isAnalysis = false;
      }

      _controller.saveInfo(_info);
    }
  }

  void _check(String url, String pageDomain) {
    _keys?.forEach((key) {
      if (url.contains(key)) {
        _controller.saveLink("https://$pageDomain");
        _info.isAnalysis = false;
        _controller.saveInfo(_info);
        return;
      }
    });
  }

  bool _isValidUrl(String? urlString) {
    try {
      return isURL(urlString);
    } on Exception {
      return false;
    }
  }

  String substringAfter(String input, String delimiter) {
    final delimiterIndex = input.indexOf(delimiter);
    if (delimiterIndex == -1) {
      return '';
    }
    return input.substring(delimiterIndex + delimiter.length);
  }

  String substringBefore(String input, String delimiter) {
    final delimiterIndex = input.indexOf(delimiter);
    if (delimiterIndex == -1) {
      return input;
    }
    return input.substring(0, delimiterIndex);
  }

  void _launchURL(BuildContext context, String url) async {
    try {
      await launch(
        url,
        customTabsOption: CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: false,
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: Theme.of(context).primaryColor,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }

  Future<void> _launchUrl(Uri uri) async {
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $uri');
  }
}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _inAppWebViewController.canGoBack()) {
          _inAppWebViewController.goBack();
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(children: [
            _progress < 1
                ? LinearProgressIndicator(
                    value: _progress,
                  )
                : const SizedBox(),
            InAppWebView(
              onProgressChanged: (controller, progress) {
                setState(() {
                  _progress = progress / 100;
                });
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                if (_isValidUrl(_link)) {
                  if (!_info.isAnalysis) {
                    var ourDomain = _controller.getLink() ?? "";
                    var startOurDomain = substringAfter(ourDomain, '//');
                    var endOurDomain = substringBefore(startOurDomain, '/');

                    var pageDomain = navigationAction.request.url.toString();
                    var startPageDomain = substringAfter(pageDomain, '//');
                    var endPageDomain = substringBefore(startPageDomain, '/');

                    if (endOurDomain != endPageDomain) {
                      _launchURL(
                          context, navigationAction.request.url.toString());
                      return NavigationActionPolicy.ALLOW;
                    }
                  }

                  return NavigationActionPolicy.CANCEL;
                } else {
                  try {
                    _launchUrl(Uri.parse(_link));
                  } catch (e) {
                    debugPrint(e.toString());
                  }

                  return NavigationActionPolicy.ALLOW;
                }
              },
              onWebViewCreated: (controller) =>
                  _inAppWebViewController = controller,
              onLoadStop: (controller, url) {
                if (_info.isAnalysis) {
                  async() {
                    var pageDomain = url.toString();
                    var startPageDomain =
                        substringAfter(pageDomain, 'https://');
                    var endPageDomain = substringBefore(startPageDomain, '/');
                    if (_info.counter > 0) {
                      _check(pageDomain, endPageDomain);
                    }
                  }
                }
              },
              androidOnPermissionRequest:
                  (controller, origin, resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
              initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(
                  mixedContentMode:
                      AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                ),
                crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true,
                  cacheEnabled: true,
                ),
              ),
              initialUrlRequest: URLRequest(url: Uri.parse(_link)),
            )
          ]),
        ),
      ),
    );
  }
}
