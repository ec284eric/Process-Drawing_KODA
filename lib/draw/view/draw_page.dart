import 'dart:typed_data';

import 'package:drawing_app/draw/view/appbar_drawing.dart';
import 'package:drawing_app/models/result/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';

import '../draw.dart';

class DrawPage extends StatefulWidget {
  static const route = '/draw';

  const DrawPage({super.key});

  @override
  State<DrawPage> createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  final _initialState = const DrawState(
    color: Colors.black,
  );

  // late final TransformationController _canvasTransformationController;
  final _canvasTransformationController = TransformationController();
  final _overlayTransformationController = TransformationController();
  late final DrawingController _drawingController;

  late final DrawBloc _bloc;
  var showTest = true;
  Uint8List? image;

  @override
  void initState() {
    super.initState();

    // _canvasTransformationController = TransformationController();

    _drawingController = DrawingController(
      config: DrawConfig(
        contentType: SimpleLine,
        strokeWidth: _initialState.strokeWidth,
        color: _initialState.color,
      ),
    )..setPaintContent(SimpleLine());

    _drawingController.addListener(() {
      _bloc.add(DrawDrawingChanged(
        canUndo: _drawingController.canUndo(),
        canRedo: _drawingController.canRedo(),
      ));
    });
    _canvasTransformationController.addListener(() {
      _overlayTransformationController.value =
          _canvasTransformationController.value;

      final zoom = _getZoomScale();
      _bloc.add(DrawZoomChanged(zoom: zoom));
    });
  }

  @override
  void dispose() {
    _drawingController.dispose();
    _canvasTransformationController.dispose();
    _overlayTransformationController.dispose();
    super.dispose();
  }

  // double _getZoomScale() {
  //   print('zooming');
  //   return _canvasTransformationController.value.getMaxScaleOnAxis();
  // }

  double _getZoomScale() {
    print('zooming');
    final scale = _canvasTransformationController.value.getMaxScaleOnAxis();

    if (scale.isNaN || scale.isInfinite || scale <= 0) {
      return 1.0;
    }

    final clampedScale = scale.clamp(0.1, 10.0);

    return clampedScale;
  }

  Future<void> _onFlipPressed(BuildContext context) async {
    final bloc = context.read<DrawBloc>();

    // bloc.add(const DrawImageProcessOpened(open: true));

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              backgroundColor: Colors.cyan,
            ),
          ),
        );
      },
    );

    bloc.add(DrawFlippedButtonPressed(controller: _drawingController));
  }

  Future<void> _requestStatusListener(
      BuildContext context, DrawState state) async {
    final bloc = context.read<DrawBloc>();

    switch (state.requestStatus) {
      case RequestStatus.waiting:
        break;

      case RequestStatus.inProgress:
        bloc.add(const DrawImageProcessOpened(open: true));

        final originalImages = state.modifiableImages;
        bloc.add(const DrawModifiableImagesCleared());

        await Future.doWhile(() async {
          await Future.delayed(const Duration(milliseconds: 10));
          return bloc.state.modifiableImages.isNotEmpty;
        });

        bloc.add(DrawWhiteBackgroundSaved(
          controller: _drawingController,
          onExported: (Uint8List? bytes) {
            bloc.add(DrawModifiableImagesRestored(images: originalImages));

            if (bytes != null) {
              bloc.add(DrawImageProcessed(imageBytes: bytes));
            }

            bloc.add(const DrawImageProcessOpened(open: false));
          },
        ));
        break;

      case RequestStatus.success:
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Drawing Saved'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;

      case RequestStatus.failure:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        _bloc = DrawBloc(
          initialState: _initialState,
        );
        return _bloc;
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<DrawBloc, DrawState>(
            listenWhen: (previous, current) =>
                previous.strokeWidth != current.strokeWidth,
            listener: (context, state) {
              _drawingController.setStyle(strokeWidth: state.strokeWidth);
            },
          ),
          BlocListener<DrawBloc, DrawState>(
            listenWhen: (previous, current) => previous.color != current.color,
            listener: (context, state) => _drawingController.setStyle(
              color: state.color,
            ),
          ),
          BlocListener<DrawBloc, DrawState>(
            listenWhen: (previous, current) =>
                previous.requestStatus != current.requestStatus,
            listener: _requestStatusListener,
          ),
          BlocListener<DrawBloc, DrawState>(
            listenWhen: (previous, current) =>
                previous.imageCollectRequestStatus !=
                current.imageCollectRequestStatus,
            listener: (context, state) {
              if (state.imageCollectRequestStatus == RequestStatus.success) {
                Navigator.of(context, rootNavigator: true)
                    .pop(); // Close dialog
              } else if (state.imageCollectRequestStatus ==
                  RequestStatus.failure) {
                Navigator.of(context, rootNavigator: true).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Image is null.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
        ],
        child: Builder(
          builder: (context) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: AppBarDrawing(
                    saveFileDialog: SaveFileDialog(
                      context: context,
                      drawingController: _drawingController,
                    ),
                  )),
              body: Stack(
                children: [
                  OverlayLayer(
                    transformationController: _canvasTransformationController,
                  ),
                  CanvasLayer(
                    drawingController: _drawingController,
                    transformationController: _canvasTransformationController,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Tools(
                      drawingController: _drawingController,
                      colorPicker: ColorPicker(
                        context: context,
                      ),
                      videoPlayerDialog: VideoPlayerDialog(
                        context: context,
                      ),
                      transformationController: _canvasTransformationController,
                      onFlipPressed: () => _onFlipPressed(context),

                      // async {
                      // print(
                      //     'here: ${(await _drawingController.getImageData())?.buffer.asUint8List()}');
                      // context.read<DrawBloc>().add(
                      //         DrawFlipPressed(
                      //           context: context,
                      //           controller: _drawingController,
                      //         ),
                      //       );
                      // },
                    ),
                  ),
                  // Builder(
                  //   builder: (context) {
                  //     final image = this.image;
                  //     if (image != null) {
                  //       return Container(
                  //         height: MediaQuery.of(context).size.height,
                  //         width: MediaQuery.of(context).size.width,
                  //         color: Colors.red,
                  //         child: Image.memory(image),
                  //       );
                  //     }
                  //     return Container();
                  //   },
                  // ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
