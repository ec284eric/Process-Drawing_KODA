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
                      'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQP5QQKcY4t1-_XAOvt_5Ii9LGJqTDX0B7u5sOZJFeU8QCGJ2jReifGEDftXkScCw-lMm8nmFUYF2QXwMR2KrzTsw'),
                  child: Image.network(
                    'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQP5QQKcY4t1-_XAOvt_5Ii9LGJqTDX0B7u5sOZJFeU8QCGJ2jReifGEDftXkScCw-lMm8nmFUYF2QXwMR2KrzTsw',
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
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
