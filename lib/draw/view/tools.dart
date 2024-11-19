import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';

class Tools extends StatelessWidget {
  final DrawingController drawingController;

  const Tools({
    super.key,
    required this.drawingController,
  });

  @override
  Widget build(BuildContext context) {
    return DrawingBoard.buildDefaultTools(
      drawingController,
      axis: Axis.vertical,
    );
  }
}
