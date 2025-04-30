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
          visible: !state.locked ? true : false,
          child: LayoutBuilder(
            builder: (context, constraint) {
              return SizedBox(
                height: constraint.maxHeight,
                width: constraint.maxWidth,
                child: Stack(
                  children: state.modifiableImages
                      .mapIndexed((index, modifiableImage) {
                    if (index == 0 && modifiableImage != null) {
                      return ModifiableImageItem(
                        modifiableImage: modifiableImage,
                        opacity: 1,
                        onScaleUpdate: (details) => bloc.add(
                          DrawImageScaleUpdated(index, details),
                        ),
                        secondImage: false,
                      );
                    } else if (index == 1 && modifiableImage != null) {
                      return ModifiableImageItem(
                        modifiableImage: modifiableImage,
                        opacity: 0.8,
                        onScaleUpdate: (details) => bloc.add(
                          DrawImageScaleUpdated(index, details),
                        ),
                        secondImage: state.imageFlipped ? true : false,
                      );
                    } else {
                      return Container();
                    }
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
