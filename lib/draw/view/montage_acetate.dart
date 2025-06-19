import 'package:drawing_app/constants/constants.dart';
import 'package:drawing_app/draw/bloc/draw_bloc.dart';
import 'package:drawing_app/draw/bloc/draw_event.dart';
import 'package:drawing_app/draw/bloc/state/draw_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drawing_app/l10n/app_localizations.dart';

class MontageAcetate extends StatefulWidget {
  const MontageAcetate({super.key});

  @override
  State<MontageAcetate> createState() => _MontageAcetateState();
}

class _MontageAcetateState extends State<MontageAcetate> {
  static const List<String> imageAssets = [
    Assets.acetateMontageImg1,
    Assets.acetateMontageImg2,
    Assets.acetateMontageImg3,
    Assets.acetateMontageImg4,
    Assets.acetateMontageImg5,
    Assets.acetateMontageImg6,
  ];

  void _imageSelected({
    required BuildContext context,
    required int index,
    required String value,
  }) {
    final bloc = context.read<DrawBloc>();
    bloc.add(DrawFirstImageSelected(
      image: value,
      index: index,
    ));
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
                        height: 500,
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
                                    bottom: 32.0,
                                    left: 8.0,
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)
                                                  ?.montageAcetates ??
                                              '',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey,
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.close_rounded,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                context.read<DrawBloc>().add(
                                                    const DrawHideMontageIconButtonPressed());
                                              });
                                            },
                                            iconSize: 20,
                                            padding: EdgeInsets.zero,
                                            splashRadius: 20,
                                            constraints: const BoxConstraints(),
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 8.0,
                                    left: 8.0,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      AppLocalizations.of(context)
                                              ?.tapToPreview ??
                                          '',
                                      style: const TextStyle(
                                        fontSize: 12,
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
                                              context: context,
                                              index: index,
                                              value: imagePath,
                                            ),
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
                    //
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
