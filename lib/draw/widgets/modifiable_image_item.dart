import 'dart:typed_data';

import 'package:drawing_app/draw/models/models.dart';
import 'package:flutter/material.dart';

class ModifiableImageItem extends StatelessWidget {
  final ModifiableImage modifiableImage;
  final ValueChanged<ScaleUpdateDetails>? onScaleUpdate;
  final VoidCallback? onScaleEnd;

  final double opacity;
  final bool secondImage;

  const ModifiableImageItem({
    super.key,
    required this.modifiableImage,
    this.onScaleUpdate,
    this.onScaleEnd,
    this.opacity = 1,
    required this.secondImage,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidth = modifiableImage.originalSize?.width;
    final imageHeight = modifiableImage.originalSize?.height ?? 550;

    final imageWidget = modifiableImage.src != null
        ? Image.asset(
            modifiableImage.src!,
            fit: BoxFit.contain,
          )
        : Image.memory(
            modifiableImage.imageBytes ?? Uint8List(0),
            fit: BoxFit.contain,
          );

    return Transform.translate(
      offset: modifiableImage.offset,
      child: Transform.scale(
        scale: modifiableImage.scale,
        child: GestureDetector(
          onScaleUpdate: onScaleUpdate,
          child: Transform.rotate(
            angle: modifiableImage.rotation,
            child: Opacity(
              opacity: opacity,
              child: Center(
                child: SizedBox(
                  width: imageWidth,
                  height: imageHeight,
                  child: secondImage
                      ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..scale(-1.0, 1.0),
                          child: Opacity(
                            opacity: opacity,
                            child: imageWidget,
                          ),
                        )
                      : imageWidget,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
