import 'package:drawing_app/draw/draw.dart';
import 'package:drawing_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';

class DrawingActions extends StatelessWidget {
  final DrawingController drawingController;
  final Widget saveFileDialog;
  final Widget videoPlayerDialog;

  const DrawingActions({
    super.key,
    required this.drawingController,
    required this.saveFileDialog,
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
        return SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => bloc.add(const DrawLockPressed()),
                    icon: Icon(state.locked ? Icons.lock : Icons.lock_open),
                  ),
                  const VerticalDivider(),
                  OutlinedButton(
                    onPressed: () => showBottomSheet(
                      context: context,
                      constraints: const BoxConstraints(
                        maxHeight: 360,
                        maxWidth: 360,
                      ),
                      builder: (context) => OverlayPickerBottomSheet(
                        onImageSelected: (value) =>
                            _firstImageSelected(context, value),
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.zero,
                      fixedSize: const Size(36, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Builder(
                      builder: (context) {
                        final modifiableImages = state.modifiableImages;
                        if (modifiableImages.isNotEmpty &&
                            modifiableImages[0] != null) {
                          final modifiableImage = modifiableImages[0];
                          if (modifiableImage != null) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                modifiableImage.src,
                                fit: BoxFit.cover,
                                height: double.infinity,
                              ),
                            );
                          } else {
                            return Container();
                          }
                        } else {
                          return const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                    padding: const EdgeInsets.only(
                      left: 4.0,
                    ),
                    child: OutlinedButton(
                      onPressed: () => showBottomSheet(
                        context: context,
                        constraints: const BoxConstraints(
                          maxHeight: 360,
                          maxWidth: 360,
                        ),
                        builder: (context) => OverlayPickerBottomSheet(
                          onImageSelected: (value) =>
                              _secondImageSelected(context, value),
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.zero,
                        fixedSize: const Size(36, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Builder(
                        builder: (context) {
                          final modifiableImages = state.modifiableImages;
                          if (modifiableImages.length > 1 &&
                              modifiableImages[1] != null) {
                            final modifiableImage = modifiableImages[1];
                            if (modifiableImage != null) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  modifiableImage.src,
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                ),
                              );
                            } else {
                              return Container();
                            }
                          } else {
                            return const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Row(
                      children: [
                        Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                ),
                                child: IconButton(
                                  onPressed: state.canUndo
                                      ? () => drawingController.undo()
                                      : null,
                                  icon: const Icon(FeatherIcons.cornerUpLeft),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: VerticalDivider(),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 8.0,
                                ),
                                child: IconButton(
                                  onPressed: state.canRedo
                                      ? () => drawingController.redo()
                                      : null,
                                  icon: const Icon(FeatherIcons.cornerUpRight),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 4.0,
                          ),
                          child: FloatingActionButton(
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => videoPlayerDialog,
                            ),
                            elevation: 2,
                            child: Builder(builder: (context) {
                              if (state.requestStatus !=
                                  RequestStatus.inProgress) {
                                return const Icon(Icons.video_settings);
                              } else {
                                return const SizedBox.square(
                                  dimension: 24,
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 4.0,
                          ),
                          child: FloatingActionButton(
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => saveFileDialog,
                            ),
                            elevation: 2,
                            child: Builder(builder: (context) {
                              if (state.requestStatus !=
                                  RequestStatus.inProgress) {
                                return const Icon(Icons.save);
                              } else {
                                return const SizedBox.square(
                                  dimension: 24,
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
