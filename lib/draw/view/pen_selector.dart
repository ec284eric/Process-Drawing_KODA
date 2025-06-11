import 'package:drawing_app/draw/bloc/draw_bloc.dart';
import 'package:drawing_app/draw/bloc/draw_event.dart';
import 'package:drawing_app/draw/bloc/state/draw_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PenSelector extends StatefulWidget {
  const PenSelector({super.key});

  @override
  State<PenSelector> createState() => _PenSelectorState();
}

class _PenSelectorState extends State<PenSelector> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawBloc, DrawState>(
      builder: (context, state) {
        final bloc = context.read<DrawBloc>();

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: !state.penSelector
              ? const SizedBox.shrink()
              : Stack(
                  children: [
                    Positioned(
                      child: Card(
                        margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  bloc.add(const BrushIconPressed(
                                    strokeWidth: 8.0,
                                  ));
                                },
                                style: FilledButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  fixedSize: const Size(36, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  side: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  backgroundColor: state.brushSelected
                                      ? Colors.black54
                                      : Colors.transparent,
                                ),
                                child: const Icon(
                                  Icons.brush,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  bloc.add(const PenIconPressed(
                                    strokeWidth: 1.5,
                                  ));
                                },
                                style: FilledButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  fixedSize: const Size(36, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  side: const BorderSide(
                                      color: Colors.white), // Border color
                                  backgroundColor: state.pencilSelected
                                      ? Colors.black54
                                      : Colors.transparent,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
