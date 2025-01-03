import 'package:drawing_app/draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:go_router/go_router.dart';

class SaveFileDialog extends StatelessWidget {
  final DrawingController drawingController;
  final BuildContext context;

  const SaveFileDialog({
    super.key,
    required this.context,
    required this.drawingController,
  });

  void _processImageBytes(BuildContext context) {
    final bloc = context.read<DrawBloc>();
    bloc.add(const DrawSavePressed());
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = this.context.read<DrawBloc>();

    return BlocProvider<DrawBloc>.value(
      value: this.context.read<DrawBloc>(),
      child: Builder(
        builder: (context) {
          return AlertDialog(
            title: const Text('Save Drawing'),
            content: TextFormField(
              onChanged: (value) => bloc.add(DrawDrawingNameChanged(value)),
              decoration: const InputDecoration(
                labelText: 'Drawing Name',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => _processImageBytes(context),
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }
}
