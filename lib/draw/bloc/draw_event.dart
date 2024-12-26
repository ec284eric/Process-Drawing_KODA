import 'package:flutter/material.dart';

sealed class DrawEvent {
  const DrawEvent();
}

class DrawDrawingChanged extends DrawEvent {
  final bool canUndo;
  final bool canRedo;

  const DrawDrawingChanged({
    this.canUndo = false,
    this.canRedo = false,
  });
}

class DrawColorChanged extends DrawEvent {
  final Color color;

  DrawColorChanged(this.color);
}

class DrawResizerScaleUpdated extends DrawEvent {
  final ScaleUpdateDetails details;

  const DrawResizerScaleUpdated(this.details);
}

class DrawImageScaleUpdated extends DrawEvent {
  final int index;
  final ScaleUpdateDetails details;

  const DrawImageScaleUpdated(this.index, this.details);
}

class DrawLockPressed extends DrawEvent {
  const DrawLockPressed();
}

class DrawFirstImageSelected extends DrawEvent {
  final String image;

  const DrawFirstImageSelected(this.image);
}

class DrawSecondImageSelected extends DrawEvent {
  final String image;

  const DrawSecondImageSelected(this.image);
}
