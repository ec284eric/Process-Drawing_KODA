import 'package:drawing_app/constants/assets.dart';
import 'package:drawing_app/draw/draw.dart';
import 'package:drawing_app/draw/view/montage_acetate.dart';
import 'package:drawing_app/draw/view/pen_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:drawing_app/l10n/app_localizations.dart';

class Tools extends StatelessWidget {
  final DrawingController drawingController;
  final Widget colorPicker;
  final Widget videoPlayerDialog;
  final TransformationController transformationController;
  final VoidCallback? onFlipPressed;

  const Tools({
    super.key,
    required this.drawingController,
    required this.colorPicker,
    required this.videoPlayerDialog,
    required this.transformationController,
    this.onFlipPressed,
  });

  Future<void> _restart(BuildContext context) async {
    final bloc = context.read<DrawBloc>();
    var result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 136, 132, 132),
          title: Text(
            AppLocalizations.of(context)?.confirmRestart ?? '',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          content: Text(
            AppLocalizations.of(context)?.restartMessage ?? '',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                AppLocalizations.of(context)?.cancel ?? '',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                AppLocalizations.of(context)?.restart ?? '',
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            )
          ],
        );
      },
    );

    if (result == null || !result) {
      return;
    }

    drawingController.clear();
    transformationController.value = Matrix4.identity();
    bloc.add(const DrawRestartButtonPressed());
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
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox.square(
                          dimension: 45,
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => videoPlayerDialog,
                              );
                            },
                            icon: Image.asset(
                              Assets.videoCamIcon,
                              width: 32,
                              height: 32,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 570,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Plus Icon
                              SizedBox.square(
                                dimension: 45,
                                child: CircleAvatar(
                                  backgroundColor:
                                      state.modifiableImages.isEmpty &&
                                              state.newDrawingSelected
                                          ? Colors.black54
                                          : Colors.transparent,
                                  child: IconButton(
                                    onPressed: state.modifiableImages.isEmpty
                                        ? () {
                                            bloc.add(const DrawIconPresed());
                                          }
                                        : null,
                                    icon: Image.asset(
                                      Assets.plusIcon,
                                      width: 32,
                                      height: 32,
                                      color: state.modifiableImages.isEmpty
                                          ? (state.newDrawingSelected
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
                                  backgroundColor: state.hideMontage &&
                                          state.modifiableImages.isNotEmpty &&
                                          state.modifiableImages.length != 2 &&
                                          !state.locked &&
                                          !state.imageFlipped
                                      ? Colors.black54
                                      : Colors.transparent,
                                  child: IconButton(
                                    onPressed: state.newDrawingSelected &&
                                            !state.locked &&
                                            !state.imageFlipped
                                        ? () {
                                            bloc.add(
                                                const DrawHideMontageIconButtonPressed());
                                            if (Navigator.of(context)
                                                .canPop()) {
                                              Navigator.of(context).pop();
                                            }
                                          }
                                        : null,
                                    icon: Image.asset(Assets.halfToneIcon,
                                        width: 32,
                                        height: 32,
                                        color: state.newDrawingSelected &&
                                                !state.locked &&
                                                !state.imageFlipped
                                            ? (state.hideMontage &&
                                                    (state.modifiableImages
                                                            .isNotEmpty &&
                                                        state.modifiableImages
                                                                .length !=
                                                            2)
                                                ? const Color.fromARGB(
                                                    255, 37, 150, 190)
                                                : Colors.white)
                                            : Colors.grey),
                                  ),
                                ),
                              ),

                              SizedBox.square(
                                dimension: 45,
                                child: CircleAvatar(
                                  backgroundColor: state.imageFlipped &&
                                          !state.drawingFlipped &&
                                          !state.locked
                                      ? Colors.black54
                                      : Colors.transparent,
                                  child: IconButton(
                                    onPressed: () => state
                                                .modifiableImages.isNotEmpty &&
                                            !state.locked
                                        ? bloc.add(
                                            const DrawImageFlippedIconButtonPressed())
                                        : null,
                                    icon: Image.asset(
                                      Assets.icon2Icon,
                                      width: 32,
                                      height: 32,
                                      color:
                                          state.modifiableImages.isNotEmpty &&
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

                              // SizedBox.square(
                              //   dimension: 45,
                              //   child: IconButton(
                              //     onPressed: () {},
                              //     icon: Image.asset(
                              //       Assets.layerIcon,
                              //       width: 32,
                              //       height: 32,
                              //       color: Colors.grey,
                              //     ),
                              //   ),
                              // ),

                              SizedBox.square(
                                dimension: 45,
                                child: CircleAvatar(
                                  backgroundColor: state.locked &&
                                          state.modifiableImages.length == 2 &&
                                          !state.drawingFlipped
                                      ? Colors.black54
                                      : Colors.transparent,
                                  child: IconButton(
                                    onPressed: (state
                                                .modifiableImages.isNotEmpty &&
                                            state.modifiableImages.length ==
                                                2 &&
                                            !state.drawingFlipped)
                                        ? () {
                                            bloc.add(const DrawLockPressed());
                                          }
                                        : null,
                                    icon: Image.asset(
                                      Assets.fileIcon,
                                      width: 32,
                                      height: 32,
                                      color: (state.modifiableImages
                                                  .isNotEmpty &&
                                              state.modifiableImages.length ==
                                                  2 &&
                                              !state.drawingFlipped)
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
                                    onPressed: (state.locked &&
                                            state.modifiableImages.isNotEmpty &&
                                            !state.drawingFlipped)
                                        ? () {
                                            bloc.add(
                                                const DrawPenSelectorButtonPressed());
                                          }
                                        : null,
                                    icon: Image.asset(
                                      Assets.editIcon,
                                      width: 32,
                                      height: 32,
                                      color: (state.locked &&
                                              state.modifiableImages
                                                  .isNotEmpty &&
                                              !state.drawingFlipped)
                                          ? (state.penSelector
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
                              //   child: IconButton(
                              //     onPressed: () => state.locked ? {} : null,
                              //     icon: Image.asset(
                              //       Assets.eraserIcon,
                              //       width: 32,
                              //       height: 32,
                              //       color: Colors.grey,
                              //     ),
                              //   ),
                              // ),
                              // SizedBox.square(
                              //   dimension: 45,
                              //   child: IconButton(
                              //     onPressed: () => state.locked
                              //         ? {
                              //             showDialog(
                              //               context: context,
                              //               builder: (context) => Dialog(
                              //                 child: colorPicker,
                              //               ),
                              //             ),
                              //           }
                              //         : null,
                              //     icon: Image.asset(
                              //       'assets/icons/color-01.png',
                              //       width: 32,
                              //       height: 32,
                              //       color:
                              //           state.locked ? state.color : Colors.grey,
                              //     ),
                              //   ),
                              // ),
                              // SizedBox.square(
                              //   dimension: 45,
                              //   child: IconButton(
                              //     onPressed: state.locked ? () {} : null,
                              //     icon: Image.asset(
                              //       'assets/icons/toggle-left.png',
                              //       width: 32,
                              //       height: 32,
                              //       color: state.locked
                              //           ? state.color
                              //           : Colors.grey,
                              //     ),
                              //   ),
                              // ),
                              SizedBox.square(
                                dimension: 45,
                                child: CircleAvatar(
                                  backgroundColor: state.isToggled
                                      ? Colors.black54
                                      : Colors.transparent,
                                  child: IconButton(
                                    onPressed: (state.pencilSelected ||
                                            state.brushSelected)
                                        ? () {
                                            final bloc =
                                                context.read<DrawBloc>();
                                            bloc.add(
                                                const DrawToggleSwitchPressed());
                                          }
                                        : null,
                                    icon: Icon(
                                      state.isToggled
                                          ? Icons.toggle_on
                                          : Icons.toggle_off,
                                      size: 30,
                                      color: (state.pencilSelected ||
                                              state.brushSelected)
                                          ? (state.isToggled
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
                                  backgroundColor: state.isLinked
                                      ? Colors.black54
                                      : Colors.transparent,
                                  child: IconButton(
                                    onPressed: state.locked
                                        ? () {
                                            bloc.add(
                                                const DrawLinkIconButtonPressed());
                                          }
                                        : null,
                                    icon: Image.asset(
                                      Assets.linkIcon,
                                      width: 23,
                                      height: 23,
                                      color: (state.drawingFlipped ||
                                              state.isLinked)
                                          ? (state.isLinked
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
                                  onPressed: state.trashEnabled
                                      ? () {
                                          bloc.add(
                                              const DrawSecondMontageDeleted());
                                        }
                                      : null,
                                  icon: Image.asset(
                                    Assets.trashIcon,
                                    width: 32,
                                    height: 32,
                                    color: state.trashEnabled
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                              ),

                              SizedBox.square(
                                dimension: 45,
                                child: IconButton(
                                  onPressed: state.canUndo
                                      ? () => drawingController.undo()
                                      : null,
                                  icon: Image.asset(
                                    Assets.undoIcon,
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
                                    Assets.redoIcon,
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
                                  onPressed: (state
                                              .modifiableImages.isNotEmpty &&
                                          state.modifiableImages.length == 2)
                                      ? () {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            transformationController.value =
                                                Matrix4.identity();
                                          });
                                        }
                                      : null,
                                  icon: Image.asset(
                                    Assets.resizeIcon,
                                    width: 32,
                                    height: 32,
                                    color: (state.locked &&
                                            state.modifiableImages.isNotEmpty &&
                                            state.modifiableImages.length == 2)
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                              SizedBox.square(
                                dimension: 45,
                                child: CircleAvatar(
                                  backgroundColor: state.drawingFlipped
                                      ? Colors.black54
                                      : Colors.transparent,
                                  child: IconButton(
                                    onPressed: (state.pencilSelected ||
                                            state.brushSelected)
                                        ? onFlipPressed
                                        : null,
                                    icon: Image.asset(
                                      Assets.copyDrawingIcon,
                                      width: 32,
                                      height: 32,
                                      color: (state.pencilSelected ||
                                              state.brushSelected)
                                          ? (state.drawingFlipped
                                              ? const Color.fromARGB(
                                                  255, 37, 150, 190)
                                              : Colors.white)
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox.square(
                          dimension: 45,
                          child: IconButton(
                            onPressed: state.newDrawingSelected &&
                                    state.modifiableImages.isNotEmpty
                                ? () => _restart(context)
                                : null,
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
                  ),
                ),
                Visibility(
                  visible: state.modifiableImages.isEmpty ||
                      state.modifiableImages.length < 2,
                  child: const Positioned(
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
