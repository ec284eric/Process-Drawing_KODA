import 'package:drawing_app/draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class DrawingActions extends StatelessWidget {
  final DrawingController drawingController;

  const DrawingActions({
    super.key,
    required this.drawingController,
  });

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
              IconButton(
                onPressed: () => bloc.add(DrawLockPressed()),
                icon: Icon(state.locked ? Icons.lock : Icons.lock_open),
              ),
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
            ],
          ),
        );
      },
    );
  }
}
