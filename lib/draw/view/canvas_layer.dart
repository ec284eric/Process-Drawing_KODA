import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';

class CanvasLayer extends StatefulWidget {
  final DrawingController drawingController;
  final TransformationController transformationController;

  const CanvasLayer({
    super.key,
    required this.drawingController,
    required this.transformationController,
  });

  @override
  State<CanvasLayer> createState() => _CanvasLayerState();
}

class _CanvasLayerState extends State<CanvasLayer> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return IgnorePointer(
          ignoring: false,
          child: DrawingBoard(
            controller: widget.drawingController,
            transformationController: widget.transformationController,
            background: Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              color: Colors.transparent,
            ),
          ),
        );
      },
    );
  }
}
