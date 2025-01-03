import 'package:drawing_app/models/models.dart';
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
        return LayoutBuilder(
          builder: (context, constraints) {
            return IgnorePointer(
              ignoring: !state.locked,
              child: DrawingBoard(
                controller: drawingController,
                transformationController: transformationController,
                background: Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  color: state.locked ? Colors.white : Colors.transparent,
                  child: Stack(
                    children: state.modifiableImages
                        .mapIndexed((index, modifiableImage) {
                      if (modifiableImage != null) {
                        return Visibility(
                          visible: state.locked &&
                              state.requestStatus == RequestStatus.waiting,
                          child: ModifiableImageItem(
                            modifiableImage: modifiableImage,
                            opacity: .5,
                            onScaleUpdate: (details) => bloc.add(
                              DrawImageScaleUpdated(index, details),
                            ),
                          ),
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
