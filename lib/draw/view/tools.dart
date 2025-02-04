import 'package:drawing_app/draw/draw.dart';
import 'package:drawing_app/draw/view/montage_acetate.dart';
import 'package:drawing_app/draw/view/pen_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
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

  Future<void> _restart(BuildContext context) async {
    final bloc = context.read<DrawBloc>();
    var result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
              'This will override your current changes and starts a new one.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Restart'),
            )
          ],
        );
      },
    );

    if (result == null || !result) {
      return;
    }

    bloc.add(const DrawRestartPressed());
  }

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
                                backgroundColor: state.hideMontage &&
                                        state.modifiableImages.isNotEmpty &&
                                        state.modifiableImages.length != 2
                                    ? Colors.black54
                                    : Colors.transparent,
                                child: IconButton(
                                  onPressed: state.newDrawingSelected &&
                                          !state.locked
                                      ? () {
                                          bloc.add(const HideMontagePressed());
                                          context.pop();
                                        }
                                      : null,
                                  icon: Image.asset(
                                    'assets/icons/half-tone-01.png',
                                    width: 32,
                                    height: 32,
                                    color: state.newDrawingSelected &&
                                            !state.locked
                                        ? (state.hideMontage &&
                                                (state.modifiableImages
                                                        .isNotEmpty &&
                                                    state.modifiableImages
                                                            .length !=
                                                        2)
                                            ? const Color.fromARGB(
                                                255, 37, 150, 190)
                                            : Colors.white)
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
                                      state.modifiableImages.length == 2 &&
                                              !state.locked
                                          ? {
                                              bloc.add(
                                                  const ImageFlippedIconPressed()),
                                            }
                                          : null,
                                  icon: Image.asset(
                                    'assets/icons/icon-02-01.png',
                                    width: 32,
                                    height: 32,
                                    color: state.modifiableImages.length == 2 &&
                                            !state.locked
                                        ? (state.imageFlipped
                                            ? const Color.fromARGB(
                                                255, 37, 150, 190)
                                            : Colors.white)
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
                                  onPressed: () => (state
                                              .modifiableImages.isNotEmpty &&
                                          state.modifiableImages.length == 2)
                                      ? {bloc.add(const DrawLockPressed())}
                                      : null,
                                  icon: Image.asset(
                                    'assets/icons/file-01.png',
                                    width: 32,
                                    height: 32,
                                    color: (state.modifiableImages.isNotEmpty &&
                                            state.modifiableImages.length == 2)
                                        ? (state.locked
                                            ? const Color.fromARGB(
                                                255, 37, 150, 190)
                                            : Colors.white)
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),

                            // SizedBox.square(
                            //   dimension: 45,
                            //   child: CircleAvatar(
                            //     backgroundColor: state.locked
                            //         ? Colors.black54
                            //         : Colors.transparent,
                            //     child: IconButton(
                            //       onPressed: () =>
                            //           {bloc.add(const DrawLockPressed())},
                            //       icon: Image.asset('assets/icons/file-01.png',
                            //           width: 32,
                            //           height: 32,
                            //           color: (state.locked
                            //               ? const Color.fromARGB(
                            //                   255, 37, 150, 190)
                            //               : Colors.white)),
                            //     ),
                            //   ),
                            // ),

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
                                        ? (state.penSelector
                                            ? const Color.fromARGB(
                                                255, 37, 150, 190)
                                            : Colors.white)
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
                                onPressed: (state.modifiableImages.isNotEmpty &&
                                        state.modifiableImages.length == 2)
                                    ? () => {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            transformationController.value =
                                                Matrix4
                                                    .identity(); // Reset zoom
                                          })
                                        }
                                    : null,
                                icon: Image.asset(
                                  'assets/icons/resize-01.png',
                                  width: 32,
                                  height: 32,
                                  color: (state.modifiableImages.isNotEmpty &&
                                          state.modifiableImages.length == 2)
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox.square(
                              dimension: 45,
                              child: IconButton(
                                onPressed: () => state.locked ? {} : null,
                                icon: Image.asset(
                                  'assets/icons/copy-drawing-01.png',
                                  width: 32,
                                  height: 32,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox.square(
                              dimension: 45,
                              child: IconButton(
                                onPressed: () => _restart(context),
                                icon: Icon(
                                  Icons.refresh,
                                  size: 32,
                                  color: state.newDrawingSelected &&
                                          state.modifiableImages.isNotEmpty
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: state.modifiableImages.isEmpty ||
                      state.modifiableImages.length < 2,
                  child: const Positioned(
                    top: 90,
                    left: 50,
                    child: MontageAcetate(),
                  ),
                ),
                Visibility(
                  visible: state.penSelector,
                  child: const Positioned(
                    top: 270,
                    left: 50,
                    child: PenSelector(),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
