import 'package:drawing_app/draw/bloc/draw_bloc.dart';
import 'package:drawing_app/draw/bloc/draw_event.dart';
import 'package:drawing_app/draw/bloc/state/draw_state.dart';
import 'package:drawing_app/draw/widgets/overlay_picker_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MontageAcetate extends StatefulWidget {
  const MontageAcetate({super.key});

  @override
  State<MontageAcetate> createState() => _MontageAcetateState();
}

class _MontageAcetateState extends State<MontageAcetate> {
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
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: !state.hideMontage
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
                                onPressed: () => showBottomSheet(
                                  context: context,
                                  constraints: const BoxConstraints(
                                    maxHeight: 360,
                                    maxWidth: 360,
                                  ),
                                  builder: (context) =>
                                      OverlayPickerBottomSheet(
                                    onImageSelected: (value) =>
                                        _firstImageSelected(context, value),
                                  ),
                                ),
                                style: FilledButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  fixedSize: const Size(36, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  side: const BorderSide(
                                      color: Colors.white), // Border color
                                  backgroundColor:
                                      Colors.white, // Button background color
                                ),
                                child: Builder(
                                  builder: (context) {
                                    final modifiableImages =
                                        state.modifiableImages;
                                    if (modifiableImages.isNotEmpty &&
                                        modifiableImages[0] != null) {
                                      final modifiableImage =
                                          modifiableImages[0];
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          modifiableImage!.src,
                                          fit: BoxFit.cover,
                                          height: double.infinity,
                                        ),
                                      );
                                    } else {
                                      return const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.image),
                                          Text('1'),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              OutlinedButton(
                                onPressed: () => showBottomSheet(
                                    context: context,
                                    constraints: const BoxConstraints(
                                      maxHeight: 360,
                                      maxWidth: 360,
                                    ),
                                    builder: (context) {
                                      return OverlayPickerBottomSheet(
                                        onImageSelected: (value) =>
                                            _secondImageSelected(
                                                context, value),
                                      );
                                    }),
                                style: FilledButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  fixedSize: const Size(36, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  side: const BorderSide(
                                      color: Colors.white), // Border color
                                  backgroundColor:
                                      Colors.white, // Button background color
                                ),
                                child: Builder(
                                  builder: (context) {
                                    final modifiableImages =
                                        state.modifiableImages;
                                    if (modifiableImages.length > 1 &&
                                        modifiableImages[1] != null) {
                                      final modifiableImage =
                                          modifiableImages[1];
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          modifiableImage!.src,
                                          fit: BoxFit.cover,
                                          height: double.infinity,
                                        ),
                                      );
                                    } else {
                                      return const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.image),
                                          Text('2'),
                                        ],
                                      );
                                    }
                                  },
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
