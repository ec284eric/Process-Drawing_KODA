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
        if (state.locked) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            transformationController.value = Matrix4.identity();
          });
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            return IgnorePointer(
              ignoring: !state.locked,
              child: InteractiveViewer(
                transformationController: transformationController,
                child: Stack(
                  children: [
                    DrawingBoard(
                      controller: drawingController,
                      transformationController: transformationController,
                      onInteractionUpdate: (p0) {},
                      onPointerUp: (pue) {},
                      background: state.imageCollectRequestStatus !=
                              RequestStatus.inProgress
                          ? SizedBox(
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                              child: Stack(
                                children: state.modifiableImages
                                    .mapIndexed((index, modifiableImage) {
                                  if (modifiableImage != null) {
                                    return ModifiableImageItem(
                                      modifiableImage: modifiableImage,
                                      opacity: 0.5,
                                      onScaleUpdate: (details) => bloc.add(
                                        DrawImageScaleUpdated(index, details),
                                      ),
                                      secondImage:
                                          index == 1 && state.imageFlipped
                                              ? true
                                              : false,
                                    );
                                  } else {
                                    return Container();
                                  }
                                }).toList(),
                              ),
                            )
                          : Container(
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                              color: Colors.transparent,
                            ),
                    ),
                    Visibility(
                      visible: state.drawingFlipped ? true : false,
                      child: Opacity(
                        opacity: state.drawingFlipped ? 1 : 0,
                        child: SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: ModifiableImageItemData(
                            modifiableImage: state.reflectedImage,
                            onScaleUpdate: state.locked
                                ? (value) => bloc
                                    .add(DrawReflectedImageScaleUpdated(value))
                                : null,
                            secondImage: false,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
