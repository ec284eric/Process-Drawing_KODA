import 'package:drawing_app/draw/draw.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OverlayLayer extends StatelessWidget {
  final TransformationController transformationController;

  const OverlayLayer({
    super.key,
    required this.transformationController,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DrawBloc>();

    return BlocBuilder<DrawBloc, DrawState>(
      builder: (context, state) {
        return InteractiveViewer(
          transformationController: transformationController,
          // panEnabled: false,
          // scaleEnabled: false,
          child: Opacity(
            opacity: .4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: state.size.height,
                width: state.size.width,
                child: Stack(
                  children: [
                    Transform.scale(
                      // scale: ,
                      child: Transform.rotate(
                        angle: state.rotation,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onScaleUpdate: (details) =>
                                  bloc.add(DrawRotatorScaleUpdated(details)),
                              child: ExtendedImage.network(
                                'https://gratisography.com/wp-content/uploads/2024/10/gratisography-cool-cat-800x525.jpg',
                                fit: BoxFit.fill,
                                // mode: ExtendedImageMode.editor,
                                height: state.size.height,
                                width: state.size.width,
                                initEditorConfigHandler: (state) {
                                  return EditorConfig(
                                    maxScale: 8.0,
                                    cropRectPadding: const EdgeInsets.all(20.0),
                                    hitTestSize: 20.0,
                                    initCropRectType:
                                        InitCropRectType.layoutRect,
                                    cropAspectRatio:
                                        MediaQuery.of(context).size.width /
                                            MediaQuery.of(context).size.height,
                                  );
                                },
                              ),
                            ),
                            // Align(
                            //   alignment: Alignment.topCenter,
                            //   child: GestureDetector(
                            //     onScaleUpdate: (details) =>
                            //         bloc.add(DrawRotatorScaleUpdated(details)),
                            //     child: Container(
                            //       height: 36,
                            //       width: 36,
                            //       decoration: const BoxDecoration(
                            //         shape: BoxShape.circle,
                            //         color: Colors.red,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onScaleUpdate: (details) =>
                            bloc.add(DrawResizerScaleUpdated(details)),
                        child: Container(
                          height: 36,
                          width: 36,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
