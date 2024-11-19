import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class OverlayLayer extends StatelessWidget {
  final TransformationController transformationController;

  const OverlayLayer({
    super.key,
    required this.transformationController,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: transformationController,
      // scaleEnabled: false,
      // panEnabled: false,

      child: Opacity(
        opacity: .4,
        child: ExtendedImage.network(
          'https://gratisography.com/wp-content/uploads/2024/10/gratisography-cool-cat-800x525.jpg',
          fit: BoxFit.contain,
          // mode: ExtendedImageMode.editor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          initEditorConfigHandler: (state) {
            return EditorConfig(
              maxScale: 8.0,
              cropRectPadding: const EdgeInsets.all(20.0),
              hitTestSize: 20.0,
              initCropRectType: InitCropRectType.layoutRect,
              cropAspectRatio: MediaQuery.of(context).size.width /
                  MediaQuery.of(context).size.height,
            );
          },
        ),
      ),
    );
    // return SizedBox(
    //   width: MediaQuery.of(context).size.width,
    //   height: MediaQuery.of(context).size.height,
    //   child: Opacity(
    //     opacity: .5,
    // child: ExtendedImage.network(
    //   'https://gratisography.com/wp-content/uploads/2024/10/gratisography-cool-cat-800x525.jpg',
    //   mode: ExtendedImageMode.editor,
    //   fit: BoxFit.contain,
    //   height: MediaQuery.of(context).size.height,
    //   width: MediaQuery.of(context).size.width,
    // initEditorConfigHandler: (state) {
    //   return EditorConfig(
    //     maxScale: 8.0,
    //     cropRectPadding: const EdgeInsets.all(20.0),
    //     hitTestSize: 20.0,
    //     initCropRectType: InitCropRectType.layoutRect,
    //     cropAspectRatio: MediaQuery.of(context).size.width /
    //         MediaQuery.of(context).size.height,
    //   );
    // },
    // ),
    //   ),
    // );
  }
}
