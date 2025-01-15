import 'package:drawing_app/draw/models/models.dart';
import 'package:flutter/material.dart';

class ModifiableImageItem extends StatelessWidget {
  final ModifiableImage modifiableImage;
  final ValueChanged<ScaleUpdateDetails>? onScaleUpdate;
  final double opacity;
  final bool secondImage;

  const ModifiableImageItem({
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
            child: Opacity(
              opacity: opacity,
              child: secondImage == true
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..scale(-1.0, 1.0),
                      child: Image.network(
                        modifiableImage.src,
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width,
                      ),
                    )
                  : Image.network(
                      modifiableImage.src,
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
