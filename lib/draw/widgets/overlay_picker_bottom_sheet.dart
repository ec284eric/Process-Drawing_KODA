import 'package:drawing_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:drawing_app/l10n/app_localizations.dart';

class OverlayPickerBottomSheet extends StatelessWidget {
  final ValueChanged<String>? onImageSelected;
  static const List<String> imageAssets = [
    Assets.acetateMontageImg1,
    Assets.acetateMontageImg2,
    Assets.acetateMontageImg3,
    Assets.acetateMontageImg4,
    Assets.acetateMontageImg5,
    Assets.acetateMontageImg6,
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
          padding: const EdgeInsets.only(
            top: 16.0,
          ),
          child: Text(
            AppLocalizations.of(context)?.chooseImage ?? '',
            style: const TextStyle(
              fontSize: 24,
            ),
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
