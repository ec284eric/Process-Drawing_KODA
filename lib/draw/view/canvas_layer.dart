// import 'package:drawing_app/draw/bloc/bloc.dart';
// import 'package:drawing_app/models/models.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_drawing_board/flutter_drawing_board.dart';
// import 'package:collection/collection.dart';
// import 'package:drawing_app/draw/widgets/widgets.dart';

// class CanvasLayer extends StatefulWidget {
//   final DrawingController drawingController;
//   final TransformationController transformationController;

//   const CanvasLayer({
//     super.key,
//     required this.drawingController,
//     required this.transformationController,
//   });

//   @override
//   State<CanvasLayer> createState() => _CanvasLayerState();
// }

// class _CanvasLayerState extends State<CanvasLayer> {
//   double? scale;
//   var offset = Offset.zero;

//   DrawState? _previousState;

//   @override
//   Widget build(BuildContext context) {
//     final bloc = context.read<DrawBloc>();

//     return BlocBuilder<DrawBloc, DrawState>(
//       builder: (context, state) {
//         // if (widget.transformationController.value != Matrix4.identity()) {
//         //   WidgetsBinding.instance.addPostFrameCallback((_) {
//         //     widget.transformationController.value = Matrix4.identity()
//         //       ..rotateZ(state.previousRotation)
//         //       ..translate(
//         //         state.modifiableImages[0]?.offset.dx ?? 0.0,
//         //         state.modifiableImages[0]?.offset.dy ?? 0.0,
//         //       );
//         //   });
//         // }

//         // Detect restart by comparing to previous state
//         if (_previousState != null &&
//             _previousState!.modifiableImages.isNotEmpty &&
//             state.modifiableImages.isEmpty) {
//           // Trigger scale and offset reset
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             setState(() {
//               scale = null;
//               offset = Offset.zero;
//             });

//             // Also reset TransformationController just in case
//             widget.transformationController.value = Matrix4.identity();
//           });
//         }

//         _previousState = state;

//         return LayoutBuilder(
//           builder: (context, constraints) {
//             print('the constraints:${state.reflectedImage.scale}');
//             return Stack(
//               children: [
//                 IgnorePointer(
//                   ignoring: !state.locked || !state.canDraw,
//                   child: DrawingBoard(
//                     // key: ValueKey(state.canUndo),
//                     key: ValueKey(state.modifiableImages.length),
//                     controller: widget.drawingController,
//                     // boardPanEnabled: false,
//                     // boardScaleEnabled: false,
//                     onInteractionUpdate: (p0) {
//                       setState(() {
//                         offset = p0.focalPointDelta;
//                         scale = p0.scale == 1.0 ? scale : p0.scale;
//                       });
//                       print('interaction: ${p0.scale}');
//                       print('interaction offset: ${p0.focalPoint}');
//                       print('interaction offset: ${p0.focalPointDelta}');
//                       print('interaction offset: ${p0.localFocalPoint}');
//                     },
//                     onInteractionEnd: (p0) {},
//                     onPointerUp: (pue) {},
//                     // background: Container(
//                     //   width: constraints.maxWidth,
//                     //   height: constraints.maxHeight,
//                     // ),

//                     background: Container(
//                       color: Colors.red,
//                       width: constraints.maxWidth,
//                       height: constraints.maxHeight,
//                       child: Visibility(
//                         visible: state.locked &&
//                             state.imageCollectRequestStatus !=
//                                 RequestStatus.inProgress &&
//                             (state.showBackground || !state.isToggled),
//                         maintainState: true,
//                         maintainAnimation: true,
//                         maintainSize: true,
//                         child: Stack(
//                           children: [
//                             ...state.modifiableImages.mapIndexed(
//                               (index, modifiableImage) {
//                                 if (modifiableImage != null && index < 2) {
//                                   return IgnorePointer(
//                                     ignoring: state.canDraw,
//                                     child: ModifiableImageItem(
//                                       modifiableImage: modifiableImage,
//                                       opacity: 0.5,
//                                       onScaleUpdate: (details) => bloc.add(
//                                         DrawImageScaleUpdated(
//                                           index: index,
//                                           details: details,
//                                         ),
//                                       ),
//                                       onScaleEnd: () => bloc.add(
//                                         DrawGestureEnded(index: index),
//                                       ),
//                                       secondImage:
//                                           index == 1 && state.imageFlipped,
//                                     ),
//                                   );
//                                 } else {
//                                   return Container();
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Visibility(
//                   visible: state.drawingFlipped,
//                   child: Container(
//                     color: Colors.yellow.withAlpha(40),
//                     // width:
//                     //     widget.drawingController.drawConfig.value.size?.width ??
//                     //         constraints.maxWidth,
//                     // height: widget
//                     //         .drawingController.drawConfig.value.size?.height ??
//                     //     constraints.maxHeight,
//                     child: ModifiableImageItem(
//                       modifiableImage: state.reflectedImage.copyWith(
//                         scale: scale ?? state.reflectedImage.scale,
//                         // offset: offset,
//                       ),
//                       onScaleUpdate: state.locked
//                           ? (value) => bloc.add(
//                                 DrawReflectedImageScaleUpdated(
//                                   details: value,
//                                 ),
//                               )
//                           : null,
//                       secondImage: true,
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }

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
