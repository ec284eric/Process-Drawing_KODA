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
          // visible: !state.locked,
          visible: true,
          child: LayoutBuilder(
            builder: (context, constraint) {
              return SizedBox(
                height: constraint.maxHeight,
                width: constraint.maxWidth,
                child: InteractiveViewer(
                  transformationController: transformationController,
                  child: Stack(
                    children: state.modifiableImages
                        .mapIndexed((index, modifiableImage) {
                      if (modifiableImage != null) {
                        return ModifiableImageItem(
                          modifiableImage: modifiableImage,
                          onScaleUpdate: (details) => bloc.add(
                            DrawImageScaleUpdated(index, details),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
