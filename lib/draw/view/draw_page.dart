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

  @override
  void initState() {
    super.initState();
    _drawingController = DrawingController(
      config: DrawConfig(
        contentType: SmoothLine,
        color: _initialState.color,
      ),
    );
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
              body: Stack(
                children: [
                  OverlayLayer(
                    transformationController: _overlayTransformationController,
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
