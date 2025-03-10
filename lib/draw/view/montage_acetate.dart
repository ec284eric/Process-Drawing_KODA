import 'package:drawing_app/draw/bloc/draw_bloc.dart';
import 'package:drawing_app/draw/bloc/draw_event.dart';
import 'package:drawing_app/draw/bloc/state/draw_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MontageAcetate extends StatefulWidget {
  const MontageAcetate({super.key});

  @override
  State<MontageAcetate> createState() => _MontageAcetateState();
}

class _MontageAcetateState extends State<MontageAcetate> {
  static const List<String> imageAssets = [
    'assets/images/image_01.jpg',
    'assets/images/image_02.jpg',
    'assets/images/image_03.jpg',
    'assets/images/image_04.jpg',
    'assets/images/image_05.jpg',
    'assets/images/image_06.jpg',
  ];

  void _imageSelected(BuildContext context, int index, String value) {
    final bloc = context.read<DrawBloc>();
    bloc.add(DrawFirstImageSelected(value, index));
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
                      child: SizedBox(
                        width: 300,
                        height: 480,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 136, 132, 132),
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 24.0,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      AppLocalizations.of(context)
                                              ?.montageAcetates ??
                                          '',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: GridView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 8,
                                        ),
                                        itemCount: imageAssets.length,
                                        itemBuilder: (context, index) {
                                          final imagePath = imageAssets[index];

                                          return InkWell(
                                            onTap: () => _imageSelected(
                                                context, index, imagePath),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: state.selectedIndex ==
                                                          index
                                                      ? Colors.blue
                                                      : Colors.grey,
                                                  width: state.selectedIndex ==
                                                          index
                                                      ? 3
                                                      : 1,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  imagePath,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
