import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';

import '../draw.dart';

class DrawPage extends StatefulWidget {
  static const route = '/draw';

  const DrawPage({super.key});

  @override
  State<DrawPage> createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  final DrawingController _drawingController = DrawingController();

  @override
  void dispose() {
    _drawingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CanvasLayer(
            drawingController: _drawingController,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Tools(
              drawingController: _drawingController,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DrawingActions(
                drawingController: _drawingController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
