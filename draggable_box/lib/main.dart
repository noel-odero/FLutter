import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// Simple MaterialApp wrapper
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GestureDetector — Draggable Color Box',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GestureDemoPage(),
    );
  }
}

class GestureDemoPage extends StatefulWidget {
  const GestureDemoPage({super.key});
  @override
  State<GestureDemoPage> createState() => _GestureDemoPageState();
}

class _GestureDemoPageState extends State<GestureDemoPage> {
  // State for the box
  Offset boxCenter = Offset.zero;
  final double baseSize = 120.0;
  double scale = 1.0;
  Color color = Colors.pinkAccent;
  String lastGesture = 'None';

  Offset _initialFocalPoint = Offset.zero;
  Offset _initialCenter = Offset.zero;
  double _initialScale = 1.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (boxCenter == Offset.zero) {
      final Size s = MediaQuery.of(context).size;
      boxCenter = Offset(s.width / 2, s.height / 2 - 80);
    }
  }

  // ---------- Gesture handlers ----------

  // Single tap -> change color randomly
  void _randomizeColor() {
    setState(() {
      color = Color(0xFF000000 | Random().nextInt(0x00FFFFFF));
      lastGesture = 'Tap → color changed';
    });
  }

  // Double tap -> toggle increase size, decrease size
  void _toggleDoubleTapSize() {
    setState(() {
      if ((scale - 1.0).abs() < 0.1) {
        scale = 1.6;
        lastGesture = 'Double tap → zoomed';
      } else {
        scale = 1.0;
        lastGesture = 'Double tap → zoom reset';
      }
    });
  }

  // Long press -> reset to center and get back to size 1.0
  void _longPressReset() {
    final Size s = MediaQuery.of(context).size;
    setState(() {
      boxCenter = Offset(s.width / 2, s.height / 2 - 80);
      scale = 1.0;
      lastGesture = 'Long press → reset';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Box reset to center'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // Scale start: capture initial focal point, center and scale
  void _onScaleStart(ScaleStartDetails details) {
    _initialFocalPoint = details.focalPoint;
    _initialCenter = boxCenter;
    _initialScale = scale;
    setState(() => lastGesture = 'Scale start');
  }

  // Scale update: handle both drag  and pinch (multi-finger)
  void _onScaleUpdate(ScaleUpdateDetails details) {
    double newScale = (_initialScale * details.scale).clamp(0.5, 3.0);

    Offset focalDelta = details.focalPoint - _initialFocalPoint;
    Offset newCenter = _initialCenter + focalDelta;

    final Size screen = MediaQuery.of(context).size;
    final double half = baseSize * newScale / 2;
    final double minX = half;
    final double maxX = screen.width - half;
    final double minY = half + 20;
    final double maxY = screen.height - half - 20;

    double clampedX = newCenter.dx.clamp(minX, maxX);
    double clampedY = newCenter.dy.clamp(minY, maxY);

    setState(() {
      scale = newScale;
      boxCenter = Offset(clampedX, clampedY);
      lastGesture = (details.scale - 1.0).abs() > 0.01
          ? 'Pinch/Zoom'
          : 'Drag/Pan';
    });
  }

  void _onScaleEnd(ScaleEndDetails details) {
    setState(() => lastGesture = 'Gesture End');
  }

  // ---------- Build UI ----------
  @override
  Widget build(BuildContext context) {
    final double displaySize = baseSize * scale;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GestureDetector — Draggable Color Box'),
      ),
      body: Stack(
        children: [
          // info card at top to show what gestures do and last gesture
          Positioned(
            left: 12,
            right: 12,
            top: 12,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Last: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(child: Text(lastGesture)),
                        const SizedBox(width: 8),
                        Text(
                          'Size: ${displaySize.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // The interactive box (positioned by its center)
          Positioned(
            left: boxCenter.dx - displaySize / 2,
            top: boxCenter.dy - displaySize / 2,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _randomizeColor,
              onDoubleTap: _toggleDoubleTapSize,
              onLongPress: _longPressReset,
              onScaleStart: _onScaleStart,
              onScaleUpdate: _onScaleUpdate,
              onScaleEnd: _onScaleEnd,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: displaySize,
                height: displaySize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  "Drag me ma'am",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
