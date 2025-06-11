import 'package:drawing_app/draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:go_router/go_router.dart';
import 'package:drawing_app/l10n/app_localizations.dart';

class SaveFileDialog extends StatelessWidget {
  final DrawingController drawingController;
  final BuildContext context;

  const SaveFileDialog({
    super.key,
    required this.context,
    required this.drawingController,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = this.context.read<DrawBloc>();

    return BlocProvider<DrawBloc>.value(
      value: this.context.read<DrawBloc>(),
      child: Builder(
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)?.saveDrawing ?? ''),
            content: TextFormField(
              onChanged: (value) =>
                  bloc.add(DrawDrawingNameChanged(value: value)),
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)?.drawingName ?? ''),
            ),
            actions: [
              TextButton(
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(
                    const Color.fromARGB(
                        255, 136, 132, 132), // Change to your desired color
                  ),
                ),
                onPressed: () => context.pop(),
                child: Text(AppLocalizations.of(context)?.cancel ?? ''),
              ),
              FilledButton(
                onPressed: () {
                  bloc.add(const DrawSavePressed());
                  context.pop();
                },
                child: Text(AppLocalizations.of(context)?.save ?? ''),
              ),
            ],
          );
        },
      ),
    );
  }
}
