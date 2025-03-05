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
  final _canvasTransformationController = TransformationController();
  final _overlayTransformationController = TransformationController();
  late final DrawingController _drawingController;
  late final DrawBloc _bloc;
  var showTest = true;
  Uint8List? image;

  @override
  void initState() {
    super.initState();
    _drawingController = DrawingController(
      config: DrawConfig(
        contentType: SmoothLine,
        strokeWidth: 8,
        color: _initialState.color,
      ),
    )..setPaintContent(SmoothLine());
    _drawingController.addListener(() {
      _bloc.add(DrawDrawingChanged(
        canUndo: _drawingController.canUndo(),
        canRedo: _drawingController.canRedo(),
      ));
    });
    _canvasTransformationController.addListener(() {
      _overlayTransformationController.value =
          _canvasTransformationController.value;
    });
  }

  @override
  void dispose() {
    _drawingController.dispose();
    super.dispose();
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

    await Future.delayed(const Duration(milliseconds: 10));

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
    bloc.add(const DrawImageProcessOpened(false));

    bloc.add(const DrawingFlippedPressed());

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _requestStatusListener(
      BuildContext context, DrawState state) async {
    switch (state.requestStatus) {
      case RequestStatus.waiting:
        break;
      case RequestStatus.inProgress:
        final bloc = context.read<DrawBloc>();
        await Future.delayed(const Duration(
          seconds: 1,
        ));
        final byteData = await _drawingController.getImageData();
        final buffer = byteData?.buffer;
        if (buffer != null) {
          bloc.add(DrawImageProcessed(Uint8List.view(buffer)));
        }
        break;
      case RequestStatus.success:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Drawing Saved'),
          behavior: SnackBarBehavior.floating,
        ));
        break;
      case RequestStatus.failure:
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
