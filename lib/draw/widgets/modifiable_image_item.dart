import 'package:drawing_app/draw/models/models.dart';
import 'package:flutter/material.dart';

class ModifiableImageItem extends StatelessWidget {
  final ModifiableImage modifiableImage;
  final ValueChanged<ScaleUpdateDetails>? onScaleUpdate;

  const ModifiableImageItem({
    super.key,
    required this.modifiableImage,
    this.onScaleUpdate,
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
            child: Stack(
              children: [
                Image.network(
                  modifiableImage.src,
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
