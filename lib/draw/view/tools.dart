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
              )
            ],
          ),
        );
      },
    );
  }
}
