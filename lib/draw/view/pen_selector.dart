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
                                    8.0,
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
                    // Positioned(
                    //   left: 1,
                    //   top: 15,
                    //   child: CustomPaint(
                    //     size: const Size(15, 15),
                    //     // painter: TrianglePainter(),
                    //     painter: TrianglePainter(),
                    //   ),
                    // ),
                    // Positioned(
                    //   left: 1,
                    //   top: 15,
                    //   child: GestureDetector(
                    //     onPanUpdate: (details) {
                    //       final localPosition = details.localPosition;

                    //       context.read<DrawBloc>().add(AddPoint(localPosition));
                    //     },
                    //     onPanEnd: (_) {
                    //       context
                    //           .read<DrawBloc>()
                    //           .add(const AddPoint(null)); // Mark end of stroke
                    //     },
                    //     child: CustomPaint(
                    //       size: const Size(200, 200), // make it bigger for test
                    //       painter: DrawingPainter(
                    //         points: state.points,
                    //         strokeWidth: state.strokeWidth,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
        );
      },
    );
  }
}

// class TrianglePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = const Color.fromARGB(255, 136, 132, 132);
//     // ..color = Colors.red;
//     final Path path = Path()
//       ..moveTo(size.width, 0) // Top right
//       ..lineTo(0, size.height / 2) // Left center (arrow point)
//       ..lineTo(size.width, size.height) // Bottom right
//       ..close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// class DrawingPainter extends CustomPainter {
//   final List<Offset?> points;
//   final double strokeWidth;

//   DrawingPainter({required this.points, required this.strokeWidth});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.black // Pencil color
//       ..strokeCap = StrokeCap.round
//       ..strokeJoin = StrokeJoin.round
//       ..strokeWidth = strokeWidth; // Use the fixed strokeWidth

//     for (int i = 0; i < points.length - 1; i++) {
//       if (points[i] != null && points[i + 1] != null) {
//         canvas.drawLine(points[i]!, points[i + 1]!, paint);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true; // Always repaint
//   }
// }
