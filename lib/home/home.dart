import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 15))
        ..repeat();
  bool activeConnection = false;
  DateTime xTime = DateTime.now();

  late DateTime currentBackPressTime = xTime;

  late WebViewPlusController myWebViewController;
  bool isWebViewLoading = true;
  bool showHome = true;

  @override
  void initState() {
    checkUserConnection();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var maxWidth = MediaQuery.of(context).size.width;
    var maxHeight = MediaQuery.of(context).size.height;
    var statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return WillPopScope(
      onWillPop: () async {
        if (showHome) {
          DateTime now = DateTime.now();
          if (now.difference(currentBackPressTime) >
              const Duration(seconds: 2)) {
            currentBackPressTime = now;
            Fluttertoast.showToast(msg: "Tap back again to close app.");
            return false;
          }
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
          return true;
        } else {
          setState(() {
            showHome = true;
          });
          return false;
        }
      },
      child: Stack(
        children: [
          Positioned(
            top: statusBarHeight,
            child: SizedBox(
                height: maxHeight - statusBarHeight,
                width: maxWidth,
                child: WebViewPlus(
                  initialUrl: 'https://mbvt.netlify.app/',
                  onWebViewCreated: (controller) {
                    myWebViewController = controller;
                  },
                  onPageFinished: (finish) {
                    Future.delayed(const Duration(seconds: 3)).then((value) {
                      setState(() {
                        isWebViewLoading = false;
                      });
                    });
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                )),
          ),
          Visibility(
              visible: showHome,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.indigo, Colors.blue, Colors.cyanAccent],
                    stops: [0.1, 0.4, 0.95],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: maxHeight * 0.8,
                      width: maxWidth,
                      child: Stack(
                        children: [
                          Center(
                              child: Container(
                            padding: const EdgeInsets.only(
                                top: 20, left: 20, right: 20, bottom: 75),
                            child: Image.asset("assets/sideElementNV.png"),
                          )),
                          Center(
                            child: AnimatedBuilder(
                              animation: _controller,
                              builder: (_, child) {
                                return Transform.rotate(
                                  angle: _controller.value * 2 * math.pi,
                                  child: child,
                                );
                              },
                              child: Image.asset("assets/circleNV.PNG",
                                  height: shortestSide / 1.5,
                                  width: shortestSide / 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DefaultTextStyle(
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 28,
                          color: Colors.black,
                          fontFamily: 'TiltNeon'),
                      textAlign: TextAlign.center,
                      child: AnimatedTextKit(
                        totalRepeatCount: 1,
                        animatedTexts: [
                          TyperAnimatedText(
                              "Raj Bhawan Dehradun",
                              speed: const Duration(milliseconds: 150)
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                        visible: isWebViewLoading,
                        child: Image.asset("assets/loader.gif")),
                    Visibility(
                        visible: !isWebViewLoading,
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  width: 2.0, color: Colors.black),
                            ),
                            onPressed: () {
                              setState(() {
                                showHome = false;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(shortestSide / 100),
                              child: const Text(
                                'Start Virtual Tour',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ))),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          activeConnection = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        activeConnection = false;
        closeApp();
      });
    }
  }

  void closeApp() {
    Fluttertoast.showToast(
        msg: "Please connect to Internet first.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3);
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }
}
