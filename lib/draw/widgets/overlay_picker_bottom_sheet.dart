import 'package:flutter/material.dart';

class OverlayPickerBottomSheet extends StatelessWidget {
  final ValueChanged<String>? onImageSelected;

  const OverlayPickerBottomSheet({
    super.key,
    this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(
            top: 16.0,
          ),
          child: Text(
            'Choose Image',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
            ),
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                InkWell(
                  onTap: () => onImageSelected?.call(
                      'https://t4.ftcdn.net/jpg/02/66/72/41/360_F_266724172_Iy8gdKgMa7XmrhYYxLCxyhx6J7070Pr8.jpg'),
                  child: Image.network(
                    'https://t4.ftcdn.net/jpg/02/66/72/41/360_F_266724172_Iy8gdKgMa7XmrhYYxLCxyhx6J7070Pr8.jpg',
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                InkWell(
                  onTap: () => onImageSelected?.call(
                      'https://static.vecteezy.com/system/resources/thumbnails/008/951/892/small_2x/cute-puppy-pomeranian-mixed-breed-pekingese-dog-run-on-the-grass-with-happiness-photo.jpg'),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..scale(-1.0, 1.0), // Flip horizontally
                    child: Image.network(
                      'https://static.vecteezy.com/system/resources/thumbnails/008/951/892/small_2x/cute-puppy-pomeranian-mixed-breed-pekingese-dog-run-on-the-grass-with-happiness-photo.jpg',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
