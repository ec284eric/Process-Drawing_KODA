import 'dart:typed_data';

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
    _drawingController.addListener(() => _bloc.add(DrawDrawingChanged(
          canUndo: _drawingController.canUndo(),
          canRedo: _drawingController.canRedo(),
        )));
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        _bloc = DrawBloc(
          initialState: _initialState,
        );
        return _bloc;
      },
      child: BlocListener<DrawBloc, DrawState>(
        listenWhen: (previous, current) => previous.color != current.color,
        listener: (context, state) => _drawingController.setStyle(
          color: state.color,
        ),
        child: Builder(
          builder: (context) {
            return Scaffold(
              // floatingActionButton: FloatingActionButton(
              //   onPressed: () async {
              //     final byteData = await _drawingController.getImageData();
              //     final buffer = byteData?.buffer;
              //     if (buffer != null) {
              //       setState(() {
              //         image = Uint8List.view(buffer);
              //       });
              //     }
              //   },
              // ),
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
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DrawingActions(
                        drawingController: _drawingController,
                      ),
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
