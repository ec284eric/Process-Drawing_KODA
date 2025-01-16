import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:collection/collection.dart';

import '../draw.dart';

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
              child: DrawingBoard(
                controller: drawingController,
                transformationController: transformationController,
                onInteractionUpdate: (p0) {},
                background: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: Stack(
                    children: state.modifiableImages
                        .mapIndexed((index, modifiableImage) {
                      if (index == 0 && modifiableImage != null) {
                        return ModifiableImageItem(
                          modifiableImage: modifiableImage,
                          opacity: 0.5,
                          onScaleUpdate: (details) => bloc.add(
                            DrawImageScaleUpdated(index, details),
                          ),
                          secondImage: false,
                        );
                      } else if (index == 1 && modifiableImage != null) {
                        return ModifiableImageItem(
                          modifiableImage: modifiableImage,
                          opacity: 0.5,
                          onScaleUpdate: (details) => bloc.add(
                            DrawImageScaleUpdated(index, details),
                          ),
                          secondImage: state.imageFlipped ? true : false,
                        );
                      } else {
                        return Container();
                      }
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
