import 'dart:typed_data';

import 'package:drawing_app/draw/models/models.dart';
import 'package:flutter/material.dart';

class ModifiableImageItem extends StatelessWidget {
  final ModifiableImage modifiableImage;
  final ValueChanged<ScaleUpdateDetails>? onScaleUpdate;
  final VoidCallback? onScaleEnd; // <-- Add this line

  final double opacity;
  final bool secondImage;

  const ModifiableImageItem({
    super.key,
    required this.modifiableImage,
    this.onScaleUpdate,
    this.onScaleEnd, // <-- Add this to the constructor
    this.opacity = 1,
    required this.secondImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleUpdate: onScaleUpdate,
      child: Transform.rotate(
        angle: modifiableImage.rotation,
        child: Opacity(
            opacity: opacity,
            child: secondImage == true
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..scale(-1.0, 1.0),
                    child: Opacity(
                      opacity: opacity,
                      child: modifiableImage.src != null
                          ? Image.asset(
                              modifiableImage.src ?? '',
                              fit: BoxFit.contain,
                              width: MediaQuery.of(context).size.width,
                            )
                          : Image.memory(
                              modifiableImage.imageBytes ?? Uint8List(0),
                              fit: BoxFit.contain,
                              width: MediaQuery.of(context).size.width,
                            ),
                    ))
                : Image.asset(
                    modifiableImage.src ?? '',
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width,
                  )),
      ),
    );
  }
}
