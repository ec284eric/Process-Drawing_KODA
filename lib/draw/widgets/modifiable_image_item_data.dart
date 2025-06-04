import 'dart:typed_data';
import 'package:drawing_app/draw/models/modifiable_image_data.dart';
import 'package:flutter/material.dart';

class ModifiableImageItemData extends StatelessWidget {
  final ModifiableImageData modifiableImage;
  final ValueChanged<ScaleUpdateDetails>? onScaleUpdate;
  final double opacity;
  final bool secondImage;

  const ModifiableImageItemData({
    super.key,
    required this.modifiableImage,
    this.onScaleUpdate,
    this.opacity = 1,
    required this.secondImage,
  });
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: modifiableImage.offset,
      child: Transform.scale(
        scale: modifiableImage.scale,
        child: GestureDetector(
          onScaleUpdate: onScaleUpdate,
          child: Transform.rotate(
            angle: modifiableImage.rotation,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..scale(-1.0, 1.0),
              child: Opacity(
                opacity: 1,
                child: Image.memory(
                  modifiableImage.src ?? Uint8List(0),
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
