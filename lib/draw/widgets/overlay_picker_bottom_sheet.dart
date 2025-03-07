import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OverlayPickerBottomSheet extends StatelessWidget {
  final ValueChanged<String>? onImageSelected;
  static const List<String> imageAssets = [
    'assets/images/image_01.jpg',
    'assets/images/image_02.jpg',
    'assets/images/image_03.jpg',
    'assets/images/image_04.jpg',
    'assets/images/image_05.jpg',
    'assets/images/image_06.jpg',
  ];

  const OverlayPickerBottomSheet({
    super.key,
    this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            AppLocalizations.of(context)?.chooseImage ?? '',
            style: const TextStyle(fontSize: 24),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: imageAssets.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => onImageSelected?.call(imageAssets[index]),
                  child: Image.asset(
                    imageAssets[index],
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    gaplessPlayback: true,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
