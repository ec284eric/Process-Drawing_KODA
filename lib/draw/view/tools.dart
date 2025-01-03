import 'package:drawing_app/draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';

class Tools extends StatelessWidget {
  final DrawingController drawingController;
  final Widget colorPicker;

  const Tools({
    super.key,
    required this.drawingController,
    required this.colorPicker,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawBloc, DrawState>(
      builder: (context, state) {
        return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox.square(
                dimension: 48,
                child: TextButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: colorPicker,
                    ),
                  ),
                  child: Container(
                    height: 24,
                    width: 24,
                    color: state.color,
                  ),
                ),
              ),
              const SizedBox.square(
                dimension: 48,
                child: TextButton(
                  onPressed: null,
                  child: Icon(Icons.layers),
                ),
              ),
              const SizedBox.square(
                dimension: 48,
                child: TextButton(
                  onPressed: null,
                  child: Icon(Icons.layers),
                ),
              ),
              const SizedBox.square(
                dimension: 48,
                child: TextButton(
                  onPressed: null,
                  child: Icon(Icons.edit_sharp),
                ),
              ),
              const SizedBox.square(
                dimension: 48,
                child: TextButton(
                  onPressed: null,
                  child: Icon(Icons.edit_outlined),
                ),
              ),
              const SizedBox.square(
                dimension: 48,
                child: TextButton(
                  onPressed: null,
                  child: Icon(Icons.remove),
                ),
              ),
              const SizedBox(
                width: 24,
                child: Divider(),
              ),
              SizedBox.square(
                dimension: 48,
                child: TextButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Text(
                          'Process and Wellness Drawing was conceived by Eric A. Chan and has been created for you.\n\n“Process Drawing”, “Wellness Drawing”, “Process and Wellness Drawing”, and “MontageAcetates” are copyright © Eric A. Chan. All rights reserved.',
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                  child: const Icon(Icons.info),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
