import 'package:drawing_app/draw/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart' as flex_color_picker;
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorPicker extends StatelessWidget {
  final BuildContext context;

  const ColorPicker({
    super.key,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = this.context.read<DrawBloc>();
    return BlocBuilder<DrawBloc, DrawState>(
      bloc: bloc,
      builder: (context, state) {
        return SizedBox(
          height: 200,
          child: flex_color_picker.ColorPicker(
            color: state.color,
            onColorChanged: (color) => bloc.add(DrawColorChanged(color)),
            pickersEnabled: const <flex_color_picker.ColorPickerType, bool>{
              flex_color_picker.ColorPickerType.both: false,
              flex_color_picker.ColorPickerType.primary: false,
              flex_color_picker.ColorPickerType.accent: false,
              flex_color_picker.ColorPickerType.bw: true,
              flex_color_picker.ColorPickerType.custom: false,
              flex_color_picker.ColorPickerType.customSecondary: false,
              flex_color_picker.ColorPickerType.wheel: false,
            },
            enableShadesSelection: false,
            enableTonalPalette: true,
            showRecentColors: true,
            recentColorsSubheading: const Text('Recent Colors'),
          ),
        );
      },
    );
  }
}
