import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MustangDetailScreen extends StatefulWidget {
  const MustangDetailScreen({super.key});

  @override
  State<MustangDetailScreen> createState() => _MustangDetailScreenState();
}

class _MustangDetailScreenState extends State<MustangDetailScreen>
    with TickerProviderStateMixin {
  late final WebViewController _controller;
  late AnimationController _webViewController;
  late AnimationController _textController;
  late AnimationController _specController;
  late AnimationController _buttonController;
  late Animation<double> _webViewScale;
  late Animation<double> _textScale;
  late Animation<double> _specScale;
  late Animation<double> _buttonScale;

  final String detailHtml = '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Mustang 3D Model</title>
  <script type="module" src="https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js"></script>
  <style>
    html, body {
      margin: 0;
      padding: 0;
      height: 100%;
      background-color: transparent;
      overflow: hidden;
    }
    model-viewer {
      width: 100vw;
      height: 100vh;
      background-color: transparent;
      display: block;
    }
  </style>
</head>
<body>
  <model-viewer id="carModel"
    src="https://raw.githubusercontent.com/syedmohamedafsal/caranimation/main/ford_mustang_1965.glb"
    alt="Mustang 3D Model"
    camera-controls
    disable-zoom
    interaction-prompt="none"
    camera-orbit="0deg 90deg 3.5m"
    style="background-color: transparent;">
  </model-viewer>

  <script>
    const model = document.getElementById('carModel');
    let start = null;
    const duration = 3000;

    function animateRotation(timestamp) {
      if (!start) start = timestamp;
      const progress = Math.min((timestamp - start) / duration, 1);
      const azimuth = progress * 390;
      const elevation = 85;
      model.cameraOrbit = azimuth + 'deg ' + elevation + 'deg 3.5m';
      if (progress < 1) {
        requestAnimationFrame(animateRotation);
      }
    }

    model.addEventListener('load', () => {
      requestAnimationFrame(animateRotation);
    });
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
      ..loadHtmlString(detailHtml);

    _webViewController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _specController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _textController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _buttonController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _webViewScale =
        CurvedAnimation(parent: _webViewController, curve: Curves.easeOutBack);
    _specScale =
        CurvedAnimation(parent: _specController, curve: Curves.easeOutBack);
    _textScale =
        CurvedAnimation(parent: _textController, curve: Curves.easeOutBack);
    _buttonScale =
        CurvedAnimation(parent: _buttonController, curve: Curves.easeOutBack);

    Future.delayed(const Duration(milliseconds: 300), () {
      _webViewController.forward();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      _specController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1300), () {
      _textController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1800), () {
      _buttonController.forward();
    });
  }

  @override
  void dispose() {
    _webViewController.dispose();
    _specController.dispose();
    _textController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07192D),
      body: SafeArea(
        child: Stack(
          children: [
            ScaleTransition(
              scale: _webViewScale,
              child: WebViewWidget(controller: _controller),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
            ),
            const Positioned(
              top: 20,
              right: 20,
              child: Icon(Icons.favorite, color: Colors.red),
            ),
            Positioned(
              top: 80,
              left: 20,
              child: ScaleTransition(
                scale: _specScale,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mustang Shelby',
                      style: GoogleFonts.pressStart2p(
                        color: Colors.white,
                        fontSize:
                            25, // Press Start 2P is very small; scale accordingly
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'GT500',
                      style: GoogleFonts.pressStart2p(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildSpecTile(CupertinoIcons.flame, 'Fuel', 'Petrol'),
                        const SizedBox(width: 10),
                        _buildSpecTile(CupertinoIcons.person_2, 'Seats', '2'),
                      ],
                    ),
                    Row(
                      children: [
                        _buildSpecTile(CupertinoIcons.bolt, 'Power', '250 kW'),
                        const SizedBox(width: 10),
                        _buildSpecTile(CupertinoIcons.timer, '0-100', '4.3s'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 550,
              left: 16,
              right: 16,
              child: ScaleTransition(
                scale: _textScale,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'The Shelby GT500 is a legendary American muscle car, blending raw power with refined design. Equipped with a supercharged 5.2L V8 engine producing over 700 horsepower, it’s built for speed and dominance. From its aggressive stance to its modern tech, the GT500 delivers an unmatched driving experience.',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: ScaleTransition(
                scale: _buttonScale,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBBFF00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Book Now',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2239),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Text(
            '$label  ',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
