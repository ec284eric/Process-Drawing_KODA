import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';

class CanvasLayer extends StatefulWidget {
  final DrawingController drawingController;

  const CanvasLayer({
    super.key,
    required this.drawingController,
  });

  @override
  State<CanvasLayer> createState() => _CanvasLayerState();
}

class _CanvasLayerState extends State<CanvasLayer> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DrawingBoard(
          controller: widget.drawingController,
          background: Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
