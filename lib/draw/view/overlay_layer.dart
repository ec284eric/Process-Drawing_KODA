import 'package:drawing_app/draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

class OverlayLayer extends StatelessWidget {
  final TransformationController transformationController;

  const OverlayLayer({
    super.key,
    required this.transformationController,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DrawBloc>();
    return BlocBuilder<DrawBloc, DrawState>(
      builder: (context, state) {
        return Visibility(
          visible: !state.locked,
          child: LayoutBuilder(
            builder: (context, constraint) {
              final canvasSize = Size(
                constraint.maxWidth,
                constraint.maxHeight,
              );

              return SizedBox(
                height: constraint.maxHeight,
                width: constraint.maxWidth,
                child: Stack(
                  children: state.modifiableImages
                      .mapIndexed((index, modifiableImage) {
                    if (modifiableImage == null) return Container();

                    return ModifiableImageItem(
                      modifiableImage: modifiableImage,
                      opacity: index == 1 ? 0.8 : 1.0,
                      onScaleUpdate: (details) => bloc.add(
                        DrawImageScaleUpdated(
                          index: index,
                          details: details,
                          canvasSize: canvasSize,
                        ),
                      ),
                      secondImage: index == 1 && state.imageFlipped,
                    );
                  }).toList(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
