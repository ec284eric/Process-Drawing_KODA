import 'package:drawing_app/draw/bloc/bloc.dart';
import 'package:drawing_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:collection/collection.dart';
import 'package:drawing_app/draw/widgets/widgets.dart';

class CanvasLayer extends StatefulWidget {
  final DrawingController drawingController;
  final TransformationController transformationController;

  const CanvasLayer({
    super.key,
    required this.drawingController,
    required this.transformationController,
  });

  @override
  State<CanvasLayer> createState() => _CanvasLayerState();
}

class _CanvasLayerState extends State<CanvasLayer> {
  double? scale;
  var offset = Offset.zero;
  DrawState? _previousState;
  bool _hasReset = false;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DrawBloc>();

    return BlocBuilder<DrawBloc, DrawState>(
      builder: (context, state) {
        if (!_hasReset &&
            _previousState?.modifiableImages.isNotEmpty == true &&
            state.modifiableImages.isEmpty) {
          _hasReset = true;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              scale = null;
              offset = Offset.zero;
            });
            widget.transformationController.value = Matrix4.identity();
          });
        }

        if (state.modifiableImages.isNotEmpty) {
          _hasReset = false;
        }

        _previousState = state;

        return LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                IgnorePointer(
                  ignoring: !state.locked || !state.canDraw,
                  child: DrawingBoard(
                    key: ValueKey(state.modifiableImages.length),
                    controller: widget.drawingController,
                    onInteractionUpdate: (p0) {
                      setState(() {
                        offset = p0.focalPointDelta;
                        scale = p0.scale == 1.0 ? scale : p0.scale;
                      });
                    },
                    onInteractionEnd: (p0) {
                      print('interaction: $p0');
                    },
                    onPointerUp: (pue) {},
                    background: SizedBox(
                      // color: Colors.red,
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: Stack(
                        alignment: Alignment.center,
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
                                          opacity: state.locked ? 0.5 : 0.9,
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
              ],
            );
          },
        );
      },
    );
  }
}
