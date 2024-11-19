import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';

class DrawingActions extends StatelessWidget {
  final DrawingController drawingController;

  const DrawingActions({
    super.key,
    required this.drawingController,
  });

  @override
  Widget build(BuildContext context) {
    return DrawingBoard.buildDefaultActions(drawingController);
  }
}
