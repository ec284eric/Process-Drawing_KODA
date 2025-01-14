import 'package:drawing_app/draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:go_router/go_router.dart';

class Tools extends StatelessWidget {
  final DrawingController drawingController;
  final Widget colorPicker;
  final Widget videoPlayerDialog;

  const Tools({
    super.key,
    required this.drawingController,
    required this.colorPicker,
    required this.videoPlayerDialog,
  });

  void _firstImageSelected(BuildContext context, String value) {
    final bloc = context.read<DrawBloc>();
    bloc.add(DrawFirstImageSelected(value));
    context.pop();
  }

  void _secondImageSelected(BuildContext context, String value) {
    final bloc = context.read<DrawBloc>();
    bloc.add(DrawSecondImageSelected(value));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DrawBloc>();

    return BlocBuilder<DrawBloc, DrawState>(
      builder: (context, state) {
        return Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox.square(
                dimension: 45,
                child: TextButton(
                  onPressed: () => {
                    showDialog(
                      context: context,
                      builder: (context) => videoPlayerDialog,
                    )
                  },
                  child: Image.asset(
                    'assets/icons/videocam-01.png',
                    width: 32,
                    height: 32,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox.square(
                dimension: 45,
                child: TextButton(
                  onPressed: () => {bloc.add(const DrawingIconPresed())},
                  child: Image.asset(
                    'assets/icons/plus-01.png',
                    width: 32,
                    height: 32,
                    color: state.drawingLocked ? Colors.black : Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: !state.drawingLocked ? 0 : null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox.square(
                          dimension: 45,
                          child: TextButton(
                            onPressed: () {
                              bloc.add(const HideMontagePressed());
                              context.pop();
                            },
                            child: Image.asset(
                              'assets/icons/half-tone-01.png',
                              width: 32,
                              height: 32,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            switchInCurve: Curves.easeIn,
                            switchOutCurve: Curves.easeOut,
                            child: !state.hideMontage
                                ? const SizedBox.shrink()
                                : Row(
                                    children: [
                                      const VerticalDivider(),
                                      OutlinedButton(
                                        onPressed: () => showBottomSheet(
                                          context: context,
                                          constraints: const BoxConstraints(
                                            maxHeight: 360,
                                            maxWidth: 360,
                                          ),
                                          builder: (context) =>
                                              OverlayPickerBottomSheet(
                                            onImageSelected: (value) =>
                                                _firstImageSelected(
                                                    context, value),
                                          ),
                                        ),
                                        style: FilledButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          fixedSize: const Size(36, 48),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Builder(
                                          builder: (context) {
                                            final modifiableImages =
                                                state.modifiableImages;
                                            if (modifiableImages.isNotEmpty &&
                                                modifiableImages[0] != null) {
                                              final modifiableImage =
                                                  modifiableImages[0];
                                              return ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  modifiableImage!.src,
                                                  fit: BoxFit.cover,
                                                  height: double.infinity,
                                                ),
                                              );
                                            } else {
                                              return const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.image),
                                                  Text('1'),
                                                ],
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: OutlinedButton(
                                          onPressed: () => showBottomSheet(
                                              context: context,
                                              constraints: const BoxConstraints(
                                                maxHeight: 360,
                                                maxWidth: 360,
                                              ),
                                              builder: (context) {
                                                return OverlayPickerBottomSheet(
                                                  onImageSelected: (value) =>
                                                      _secondImageSelected(
                                                          context, value),
                                                );
                                              }),
                                          style: FilledButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            fixedSize: const Size(36, 48),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Builder(
                                            builder: (context) {
                                              final modifiableImages =
                                                  state.modifiableImages;
                                              if (modifiableImages.length > 1 &&
                                                  modifiableImages[1] != null) {
                                                final modifiableImage =
                                                    modifiableImages[1];
                                                return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.network(
                                                    modifiableImage!.src,
                                                    fit: BoxFit.cover,
                                                    height: double.infinity,
                                                  ),
                                                );
                                              } else {
                                                return const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.image),
                                                    Text('2'),
                                                  ],
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      const VerticalDivider(),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox.square(
                      dimension: 45,
                      child: TextButton(
                        onPressed: () => {},
                        child: Image.asset(
                          'assets/icons/icon-02-01.png',
                          width: 32,
                          height: 32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox.square(
                      dimension: 45,
                      child: TextButton(
                        onPressed: () => {},
                        child: Image.asset(
                          'assets/icons/layer-01.png',
                          width: 32,
                          height: 32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox.square(
                      dimension: 45,
                      child: TextButton(
                        onPressed: () => {},
                        child: Image.asset(
                          'assets/icons/file-01.png',
                          width: 32,
                          height: 32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox.square(
                      dimension: 45,
                      child: TextButton(
                        onPressed: () => {},
                        child: Image.asset(
                          'assets/icons/edit-01.png',
                          width: 32,
                          height: 32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox.square(
                      dimension: 45,
                      child: TextButton(
                        onPressed: () => {},
                        child: Image.asset(
                          'assets/icons/eraser-01.png',
                          width: 32,
                          height: 32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox.square(
                      dimension: 45,
                      child: TextButton(
                        onPressed: () => {},
                        child: Image.asset(
                          'assets/icons/color-01.png',
                          width: 32,
                          height: 32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox.square(
                      dimension: 45,
                      child: TextButton(
                        onPressed: () => {},
                        child: Image.asset(
                          'assets/icons/undo-01.png',
                          width: 32,
                          height: 32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox.square(
                      dimension: 45,
                      child: TextButton(
                        onPressed: () => {},
                        child: Image.asset(
                          'assets/icons/redo-01.png',
                          width: 32,
                          height: 32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox.square(
                      dimension: 45,
                      child: TextButton(
                        onPressed: () => {},
                        child: Image.asset(
                          'assets/icons/resize-01.png',
                          width: 32,
                          height: 32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // SizedBox.square(
              //   dimension: 48,
              //   child: TextButton(
              //     onPressed: () => showDialog(
              //       context: context,
              //       builder: (context) => Dialog(
              //         child: colorPicker,
              //       ),
              //     ),
              //     child: Container(
              //       height: 24,
              //       width: 24,
              //       color: state.color,
              //     ),
              //   ),
              // ),
              // const SizedBox.square(
              //   dimension: 48,
              //   child: TextButton(
              //     onPressed: null,
              //     child: Icon(Icons.layers_outlined),
              //   ),
              // ),
              // const SizedBox.square(
              //   dimension: 48,
              //   child: TextButton(
              //     onPressed: null,
              //     child: Icon(Icons.layers),
              //   ),
              // ),
              // const SizedBox.square(
              //   dimension: 48,
              //   child: TextButton(
              //     onPressed: null,
              //     child: Icon(Icons.edit_sharp),
              //   ),
              // ),
              // const SizedBox.square(
              //   dimension: 48,
              //   child: TextButton(
              //     onPressed: null,
              //     child: Icon(Icons.edit_outlined),
              //   ),
              // ),
              // const SizedBox.square(
              //   dimension: 48,
              //   child: TextButton(
              //     onPressed: null,
              //     child: Icon(Icons.remove),
              //   ),
              // ),
              // const SizedBox(
              //   width: 24,
              //   child: Divider(),
              // ),
              // SizedBox.square(
              //   dimension: 48,
              //   child: TextButton(
              //     onPressed: () => showDialog(
              //       context: context,
              //       builder: (context) {
              //         return const AlertDialog(
              //           content: Text(
              //             'Process and Wellness Drawing was conceived by Eric A. Chan and has been created for you.\n\n“Process Drawing”, “Wellness Drawing”, “Process and Wellness Drawing”, and “MontageAcetates” are copyright © Eric A. Chan. All rights reserved.',
              //             textAlign: TextAlign.center,
              //           ),
              //         );
              //       },
              //     ),
              //     child: const Icon(Icons.info),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
