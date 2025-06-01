import 'package:caranimation/deatil/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const PorcheApp());
}

class PorcheApp extends StatelessWidget {
  const PorcheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mustang 3D UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF07192D),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const MustangHome(),
    );
  }
}

class MustangHome extends StatefulWidget {
  const MustangHome({super.key});

  @override
  State<MustangHome> createState() => _MustangHomeState();
}

class _MustangHomeState extends State<MustangHome>
    with SingleTickerProviderStateMixin {
  late final WebViewController _controller;
  late AnimationController _fadeSlideController;

  final String htmlContent = '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Mustang 3D Model</title>
  <script type="module" src="https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js"></script>
  <style>
    body, html {
      margin: 0;
      padding: 0;
      height: 100vh;
      background-color: transparent;
      overflow: hidden;
    }
    model-viewer {
      width: 350px;
      height: 310px;
      background-color: transparent;
      margin: auto;
      display: block;
      pointer-events: auto;
      touch-action: none;
    }
    model-viewer.no-interaction {
      pointer-events: none;
    }
  </style>
</head>
<body>
  <model-viewer id="carModel"
    src="https://raw.githubusercontent.com/syedmohamedafsal/caranimation/main/ford_mustang_1965.glb"
    alt="Mustang 3D Model"
    camera-controls
    disable-zoom
    camera-orbit="90deg 75deg 3m"
    style="background-color: transparent;"
  ></model-viewer>
  <script>
    const model = document.getElementById('carModel');
    let startAngle = 90;
    let endAngle = 0;
    let startZoom = 3;
    let endZoom = 1.5;
    let duration = 4000;
    let start = null;

    function animate(timestamp) {
      if (!start) start = timestamp;
      let progress = (timestamp - start) / duration;
      if (progress > 1) progress = 1;

      let angle = startAngle + (endAngle - startAngle) * progress;
      let zoom = startZoom + (endZoom - startZoom) * progress;

      model.cameraOrbit = angle + "deg 75deg " + zoom + "m";

      if (progress < 1) {
        requestAnimationFrame(animate);
      } else {
        model.removeAttribute('camera-controls');
        model.classList.add('no-interaction');
      }
    }

    model.addEventListener('load', () => {
      requestAnimationFrame(animate);
    });

    function rotateCar360() {
      let startAngle = 0;
      let endAngle = 360;
      let duration = 4000;
      let start = null;

      function animateRotate(timestamp) {
        if (!start) start = timestamp;
        let progress = (timestamp - start) / duration;
        if (progress > 1) progress = 1;

        let angle = startAngle + (endAngle - startAngle) * progress;
        model.cameraOrbit = angle + "deg 75deg 1.5m";

        if (progress < 1) {
          requestAnimationFrame(animateRotate);
        }
      }

      requestAnimationFrame(animateRotate);
    }
  </script>
</body>
</html>
''';

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel('RotateChannel',
          onMessageReceived: (JavaScriptMessage message) {})
      ..loadHtmlString(htmlContent);

    _fadeSlideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..forward();
  }

  @override
  void dispose() {
    _fadeSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: _fadeSlideController,
      curve: Curves.easeInOut,
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(animation),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFF10264D),
                  borderRadius: BorderRadius.circular(36),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.close, color: Colors.white54),
                    const SizedBox(height: 20),
                    const Text(
                      "Retro",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "1st week",
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 400,
                          height: 310,
                          child: WebViewWidget(controller: _controller),
                        ),
                        Positioned(
                          top: 10,
                          left: 80,
                          child: GestureDetector(
                            onTap: () {
                              _controller.runJavaScript('rotateCar360();');
                            },
                            child: const Icon(
                              Icons.threesixty,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 80,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 600),
                                  pageBuilder: (_, __, ___) => const MustangDetailScreen(),
                                  transitionsBuilder: (context, animation, _, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(1, 0),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            child: Hero(
                              tag: 'mustang-hero',
                              child: Image.asset(
                                'assets/images/mustang.png',
                                width: 55,
                                height: 50,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.shade700,
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.angleLeft,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Mustang Shelby GT500",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    const Text("Ford",
                        style: TextStyle(color: Colors.white54, fontSize: 14)),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const FaIcon(FontAwesomeIcons.gauge, color: Colors.white),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFF2952A3), Color(0xFF12326C)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const FaIcon(FontAwesomeIcons.powerOff,
                              color: Colors.white),
                        ),
                        const FaIcon(FontAwesomeIcons.bell, color: Colors.white),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
