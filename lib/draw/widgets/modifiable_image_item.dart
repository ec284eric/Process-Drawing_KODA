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
        child: Transform.rotate(
          angle: modifiableImage.rotation,
          child: Stack(
            children: [
              GestureDetector(
                onScaleUpdate: onScaleUpdate,
                child: Image.network(
                  'https://gratisography.com/wp-content/uploads/2024/10/gratisography-cool-cat-800x525.jpg',
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
