import 'package:drawing_app/draw/bloc/bloc.dart';
import 'package:drawing_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:collection/collection.dart';
import 'package:drawing_app/draw/widgets/widgets.dart';

class CanvasLayer extends StatelessWidget {
  final DrawingController drawingController;
  final TransformationController transformationController;

  const CanvasLayer({
    super.key,
    required this.drawingController,
    required this.transformationController,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DrawBloc>();

    return BlocBuilder<DrawBloc, DrawState>(
      builder: (context, state) {
        if (transformationController.value != Matrix4.identity()) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            transformationController.value = Matrix4.identity()
              ..rotateZ(state.previousRotation)
              ..translate(
                state.modifiableImages[0]?.offset.dx ?? 0.0,
                state.modifiableImages[0]?.offset.dy ?? 0.0,
              );
          });
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                IgnorePointer(
                  ignoring: !state.locked || !state.canDraw,
                  child: DrawingBoard(
                    controller: drawingController,
                    onInteractionUpdate: (p0) {},
                    onInteractionEnd: (p0) {
                      print('interaction: $p0');
                    },
                    onPointerUp: (pue) {},
                    background: SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: Stack(
                        children: [
                          Visibility(
                            visible: state.locked &&
                                state.imageCollectRequestStatus !=
                                    RequestStatus.inProgress &&
                                (state.showBackground || !state.isToggled),
                            maintainState: true,
                            maintainAnimation: true,
                            maintainSize: true,
                            child: Stack(
                              children: [
                                ...state.modifiableImages.mapIndexed(
                                  (index, modifiableImage) {
                                    if (modifiableImage != null) {
                                      return IgnorePointer(
                                        ignoring: state.canDraw,
                                        child: ModifiableImageItem(
                                          modifiableImage: modifiableImage,
                                          opacity: 0.5,
                                          onScaleUpdate: (details) => bloc.add(
                                            DrawImageScaleUpdated(
                                              index: index,
                                              details: details,
                                            ),
                                          ),
                                          onScaleEnd: () => bloc.add(
                                            DrawGestureEnded(index: index),
                                          ),
                                          secondImage:
                                              index == 1 && state.imageFlipped,
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: state.drawingFlipped,
                            child: SizedBox(
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                              child: ModifiableImageItem(
                                modifiableImage: state.reflectedImage,
                                onScaleUpdate: state.locked
                                    ? (value) => bloc.add(
                                          DrawReflectedImageScaleUpdated(
                                            details: value,
                                          ),
                                        )
                                    : null,
                                secondImage: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Visibility(
                //   visible: state.drawingFlipped,
                //   child: SizedBox(
                //     width: constraints.maxWidth,
                //     height: constraints.maxHeight,
                //     child: ModifiableImageItem(
                //       modifiableImage: state.reflectedImage
                //           .copyWith(scale: 0.23453973308252418),
                //       onScaleUpdate: state.locked
                //           ? (value) => bloc.add(
                //                 DrawReflectedImageScaleUpdated(
                //                   details: value,
                //                 ),
                //               )
                //           : null,
                //       secondImage: true,
                //     ),
                //   ),
                // ),
              ],
            );
          },
        );
      },
    );
  }
}
