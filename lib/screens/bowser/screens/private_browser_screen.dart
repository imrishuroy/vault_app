import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PrivateBrowserScreen extends StatefulWidget {
  static const routeName = '/private_browser';
  final ChromeSafariBrowser browser = MyChromeSafariBrowser();

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => PrivateBrowserScreen(),
    );
  }

  PrivateBrowserScreen({Key? key}) : super(key: key);

  @override
  PrivateBrowserScreenState createState() => PrivateBrowserScreenState();
}

class PrivateBrowserScreenState extends State<PrivateBrowserScreen> {
  webviewInit() async {
    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

      var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
          AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
          AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

      if (swAvailable && swInterceptAvailable) {
        AndroidServiceWorkerController serviceWorkerController =
            AndroidServiceWorkerController.instance();

        await serviceWorkerController
            .setServiceWorkerClient(AndroidServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            print(request);
            return null;
          },
        ));
      }
    }
  }

  @override
  void initState() {
    webviewInit();
    rootBundle.load('assets/images/flutter-logo.png').then((actionButtonIcon) {
      widget.browser.setActionButton(ChromeSafariBrowserActionButton(
          id: 1,
          description: 'Action Button description',
          icon: actionButtonIcon.buffer.asUint8List(),
          action: (url, title) {
            print('Action Button 1 clicked!');
            print(url);
            print(title);
          }));
    });

    widget.browser.addMenuItem(ChromeSafariBrowserMenuItem(
        id: 2,
        label: 'Custom item menu 1',
        action: (url, title) {
          print('Custom item menu 1 clicked!');
          print(url);
          print(title);
        }));
    widget.browser.addMenuItem(ChromeSafariBrowserMenuItem(
        id: 3,
        label: 'Custom item menu 2',
        action: (url, title) {
          print('Custom item menu 2 clicked!');
          print(url);
          print(title);
        }));
    super.initState();
  }

  //InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Private Browser',
        ),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse('https://google.com/'),
        ),
        initialOptions: InAppWebViewGroupOptions(
          android: AndroidInAppWebViewOptions(
            safeBrowsingEnabled: true,
            disableDefaultErrorPage: true,
            supportMultipleWindows: true,
            useHybridComposition: true,
            verticalScrollbarThumbColor: const Color.fromRGBO(0, 0, 0, 0.5),
            horizontalScrollbarThumbColor: const Color.fromRGBO(0, 0, 0, 0.5),
          ),
          ios: IOSInAppWebViewOptions(
            //  sharedCookiesEnabled: true,
            allowsLinkPreview: true,
            isFraudulentWebsiteWarningEnabled: true,
            disableLongPressContextMenuOnLinks: true,
            // allowingReadAccessTo: Uri.parse(
            //   'file://$WEB_ARCHIVE_DIR/',
            // ),
          ),
          crossPlatform: InAppWebViewOptions(
            incognito: true,
            useOnDownloadStart: true,
            useOnLoadResource: true,
            useShouldOverrideUrlLoading: true,
            javaScriptCanOpenWindowsAutomatically: true,
            userAgent:
                'Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36',
            transparentBackground: false,
          ),
        ),
      ),
    );

    //  Center(
    //   child: ElevatedButton(
    //       onPressed: () async {
    //         await widget.browser.open(
    //             url: Uri.parse('https://google.com/'),
    //             options: ChromeSafariBrowserClassOptions(
    //                 android: AndroidChromeCustomTabsOptions(
    //                     shareState: CustomTabsShareState.SHARE_STATE_OFF,
    //                     isSingleInstance: false,
    //                     isTrustedWebActivity: false,

    //                     keepAliveEnabled: true),
    //                 ios: IOSSafariOptions(
    //                     dismissButtonStyle:
    //                         IOSSafariDismissButtonStyle.CLOSE,
    //                     presentationStyle:
    //                         IOSUIModalPresentationStyle.OVER_FULL_SCREEN)));
    //       },
    //       child: const Text('Open Chrome Safari Browser')),
    // ));
  }
}

class MyChromeSafariBrowser extends ChromeSafariBrowser {
  @override
  void onOpened() {
    print('ChromeSafari browser opened');
  }

  @override
  void onCompletedInitialLoad() {
    print('ChromeSafari browser initial load completed');
  }

  @override
  void onClosed() {
    print('ChromeSafari browser closed');
  }
}
