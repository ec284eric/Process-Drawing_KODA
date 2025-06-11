import 'dart:typed_data';
import 'dart:ui' as ui;

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

      // _updateDynamicStrokeWidth();
    });
  }

  @override
  void dispose() {
    _drawingController.dispose();
    _canvasTransformationController.dispose();
    _overlayTransformationController.dispose();
    super.dispose();
  }

  double _getZoomScale() {
    return _canvasTransformationController.value.getMaxScaleOnAxis();
  }

  void _updateDynamicStrokeWidth() {
    final zoom = _getZoomScale();
    final state = _bloc.state;
    final baseStrokeWidth = state.strokeWidth;

    double adjustedWidth = baseStrokeWidth;

    if (state.pencilSelected) {
      adjustedWidth = baseStrokeWidth / (zoom * 2);
    } else if (state.brushSelected) {
      adjustedWidth = baseStrokeWidth / (zoom * 3);
    }

    _drawingController.setStyle(strokeWidth: adjustedWidth);
  }

  Future<Uint8List?> _exportWithWhiteBackground(
    DrawState state,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    const int width = 2048;
    const int height = 1536;

    final backgroundPaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
        backgroundPaint);

    final byteData = await _drawingController.getImageData();
    if (byteData == null) return null;

    final codec = await ui.instantiateImageCodec(byteData.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    final drawingImage = frame.image;

    final dx = (width - drawingImage.width) / 2;
    final dy = (height - drawingImage.height) / 2;
    final offset = Offset(dx, dy);

    canvas.drawImage(drawingImage, offset, Paint());

    if (state.drawingFlipped) {
      canvas.save();
      canvas.translate(width.toDouble(), 0);
      canvas.scale(-1, 1);
      canvas.drawImage(drawingImage, offset, Paint());
      canvas.restore();
    } else {
      canvas.drawImage(drawingImage, offset, Paint());
    }

    final composedImage = await recorder.endRecording().toImage(width, height);
    final pngBytes =
        await composedImage.toByteData(format: ui.ImageByteFormat.png);

    return pngBytes?.buffer.asUint8List();
  }

  Future<void> _onFlipPressed(BuildContext context) async {
    final bloc = context.read<DrawBloc>();

    bloc.add(const DrawImageProcessOpened(true));

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

    await Future.delayed(const Duration(milliseconds: 5));

    final Uint8List? data =
        (await _drawingController.getImageData())?.buffer.asUint8List();

    if (data == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Image null'),
          behavior: SnackBarBehavior.floating,
        ));
        Navigator.of(context).pop();
      }

      return;
    }

    bloc.add(DrawPaintedImageCollected(data.buffer.asUint8List()));

    bloc.add(const DrawingFlippedPressed());

    bloc.add(const DrawImageProcessOpened(false));

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _requestStatusListener(
      BuildContext context, DrawState state) async {
    final bloc = context.read<DrawBloc>();

    switch (state.requestStatus) {
      case RequestStatus.waiting:
        break;

      case RequestStatus.inProgress:
        bloc.add(const DrawImageProcessOpened(true));

        final originalImages = state.modifiableImages;

        bloc.add(const DrawClearModifiableImages());

        await Future.doWhile(() async {
          await Future.delayed(const Duration(milliseconds: 10));
          return bloc.state.modifiableImages.isNotEmpty;
        });

        final Uint8List? bytes = await _exportWithWhiteBackground(state);

        bloc.add(DrawRestoreModifiableImages(originalImages));

        if (bytes != null) {
          bloc.add(DrawImageProcessed(bytes));
        }

        bloc.add(const DrawImageProcessOpened(false));
        break;

      case RequestStatus.success:
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Drawing Saved'),
          behavior: SnackBarBehavior.floating,
        ));
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
                previous.strokeWidth != current.strokeWidth ||
                previous.pencilSelected != current.pencilSelected ||
                previous.brushSelected != current.brushSelected,
            listener: (context, state) => _updateDynamicStrokeWidth(),
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
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      final image = this.image;
                      if (image != null) {
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.red,
                          child: Image.memory(image),
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
