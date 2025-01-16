import 'package:drawing_app/draw/bloc/draw_bloc.dart';
import 'package:drawing_app/draw/bloc/draw_event.dart';
import 'package:drawing_app/draw/bloc/state/draw_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PenSelector extends StatefulWidget {
  const PenSelector({super.key});

  @override
  State<PenSelector> createState() => _PenSelectorState();
}

class _PenSelectorState extends State<PenSelector> {
  void _firstImageSelected(BuildContext context, String value) {
    final bloc = context.read<DrawBloc>();
    bloc.add(DrawFirstImageSelected(value));
    context.pop();
  }

  void _secondImageSelected(BuildContext context, String value) {
    final bloc = context.read<DrawBloc>();
    bloc.add(DrawSecondImageSelected(value));
    context.pop();
  }

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
                                  bloc.add(const BrushIconPressed());
                                },
                                style: FilledButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  fixedSize: const Size(36, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  side: const BorderSide(
                                    color: Colors.white,
                                  ), // Border color
                                  backgroundColor: state.brushSelected
                                      ? Colors.black54
                                      : Colors
                                          .transparent, // Button background color
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
                                  bloc.add(const PenIconPressed());
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
                                      : Colors
                                          .transparent, // Button background color
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
                    Positioned(
                      left: 1,
                      top: 15,
                      child: CustomPaint(
                        size: const Size(15, 15),
                        painter: TrianglePainter(),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color.fromARGB(255, 136, 132, 132);
    // ..color = Colors.red;
    final Path path = Path()
      ..moveTo(size.width, 0) // Top right
      ..lineTo(0, size.height / 2) // Left center (arrow point)
      ..lineTo(size.width, size.height) // Bottom right
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
