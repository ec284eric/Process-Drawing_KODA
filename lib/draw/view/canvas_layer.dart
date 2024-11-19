import 'package:extended_image/extended_image.dart';
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
            background: Stack(
              children: [
                Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  color: Colors.transparent,
                ),
                // Opacity(
                //   opacity: .2,
                //   child: ExtendedImage.network(
                //     'https://gratisography.com/wp-content/uploads/2024/10/gratisography-cool-cat-800x525.jpg',
                //     mode: ExtendedImageMode.editor,
                //     fit: BoxFit.contain,
                //     height: 200,
                //     width: 200,
                //     initEditorConfigHandler: (state) {
                //       return EditorConfig(
                //         maxScale: 8.0,
                //         cropRectPadding: const EdgeInsets.all(20.0),
                //         hitTestSize: 20.0,
                //         cropAspectRatio: 1,
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
