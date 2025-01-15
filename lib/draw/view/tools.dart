import 'package:drawing_app/draw/draw.dart';
import 'package:drawing_app/draw/view/montage_acetate.dart';
import 'package:drawing_app/draw/view/pen_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:go_router/go_router.dart';

class Tools extends StatelessWidget {
  final DrawingController drawingController;
  final Widget colorPicker;
  final Widget videoPlayerDialog;
  final TransformationController transformationController;

  const Tools({
    super.key,
    required this.drawingController,
    required this.colorPicker,
    required this.videoPlayerDialog,
    required this.transformationController,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DrawBloc>();

    return BlocBuilder<DrawBloc, DrawState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Card(
                    margin: const EdgeInsets.all(0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox.square(
                          dimension: 45,
                          child: IconButton(
                            onPressed: () => {
                              showDialog(
                                context: context,
                                builder: (context) => videoPlayerDialog,
                              )
                            },
                            icon: Image.asset(
                              'assets/icons/videocam-01.png',
                              width: 32,
                              height: 32,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox.square(
                          dimension: 45,
                          child: IconButton(
                            onPressed: () => {
                              bloc.add(const DrawingIconPresed()),
                            },
                            icon: Image.asset(
                              'assets/icons/plus-01.png',
                              width: 32,
                              height: 32,
                              color: state.modifiableImages.isEmpty
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox.square(
                              dimension: 45,
                              child: CircleAvatar(
                                backgroundColor: state.hideMontage
                                    ? Colors.black54
                                    : Colors.transparent,
                                child: IconButton(
                                  onPressed: () => state.newDrawingSelected
                                      ? {
                                          bloc.add(const HideMontagePressed()),
                                          context.pop(),
                                        }
                                      : null,
                                  icon: Image.asset(
                                    'assets/icons/half-tone-01.png',
                                    width: 32,
                                    height: 32,
                                    color: state.newDrawingSelected
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox.square(
                              dimension: 45,
                              child: CircleAvatar(
                                backgroundColor: state.imageFlipped
                                    ? Colors.black54
                                    : Colors.transparent,
                                child: IconButton(
                                  onPressed: () =>
                                      state.modifiableImages.length == 2
                                          ? {
                                              bloc.add(
                                                  const ImageFlippedIconPressed()),
                                            }
                                          : null,
                                  icon: Image.asset(
                                    'assets/icons/icon-02-01.png',
                                    width: 32,
                                    height: 32,
                                    color: state.modifiableImages.length == 2
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox.square(
                              dimension: 45,
                              child: IconButton(
                                onPressed: () => {},
                                icon: Image.asset(
                                  'assets/icons/layer-01.png',
                                  width: 32,
                                  height: 32,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox.square(
                              dimension: 45,
                              child: CircleAvatar(
                                backgroundColor: state.locked &&
                                        state.modifiableImages.length == 2
                                    ? Colors.black54
                                    : Colors.transparent,
                                child: IconButton(
                                  onPressed: () =>
                                      state.modifiableImages.length == 2
                                          ? {bloc.add(const DrawLockPressed())}
                                          : null,
                                  icon: Image.asset(
                                    'assets/icons/file-01.png',
                                    width: 32,
                                    height: 32,
                                    color: state.modifiableImages.isNotEmpty
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox.square(
                              dimension: 45,
                              child: CircleAvatar(
                                backgroundColor: state.penSelector &&
                                        state.modifiableImages.isNotEmpty
                                    ? Colors.black54
                                    : Colors.transparent,
                                child: IconButton(
                                  onPressed: () => state
                                          .modifiableImages.isNotEmpty
                                      ? {bloc.add(const PenSelectorPressed())}
                                      : null,
                                  icon: Image.asset(
                                    'assets/icons/edit-01.png',
                                    width: 32,
                                    height: 32,
                                    color: state.locked
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox.square(
                              dimension: 45,
                              child: IconButton(
                                onPressed: () => state.locked ? {} : null,
                                icon: Image.asset(
                                  'assets/icons/eraser-01.png',
                                  width: 32,
                                  height: 32,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            // SizedBox.square(
                            //   dimension: 45,
                            //   child: IconButton(
                            // onPressed: () => state.locked
                            //     ? {
                            //         showDialog(
                            //           context: context,
                            //           builder: (context) => Dialog(
                            //             child: colorPicker,
                            //           ),
                            //         ),
                            //       }
                            //     : null,
                            //     icon: Image.asset(
                            //       'assets/icons/color-01.png',
                            //       width: 32,
                            //       height: 32,
                            //       color:
                            //           state.locked ? state.color : Colors.grey,
                            //     ),
                            //   ),
                            // ),
                            SizedBox.square(
                              dimension: 45,
                              child: IconButton(
                                onPressed: state.canUndo
                                    ? () => drawingController.undo()
                                    : null,
                                icon: Image.asset(
                                  'assets/icons/undo-01.png',
                                  width: 32,
                                  height: 32,
                                  color: state.canUndo
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox.square(
                              dimension: 45,
                              child: IconButton(
                                onPressed: state.canRedo
                                    ? () => drawingController.redo()
                                    : null,
                                icon: Image.asset(
                                  'assets/icons/redo-01.png',
                                  width: 32,
                                  height: 32,
                                  color: state.canRedo
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox.square(
                              dimension: 45,
                              child: IconButton(
                                onPressed: () => {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    transformationController.value =
                                        Matrix4.identity(); // Reset zoom
                                  })
                                },
                                icon: Image.asset(
                                  'assets/icons/resize-01.png',
                                  width: 32,
                                  height: 32,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Positioned(top: 90, left: 50, child: MontageAcetate()),
                const Positioned(top: 270, left: 50, child: PenSelector()),
              ],
            ),
          ],
        );
      },
    );
  }
}
