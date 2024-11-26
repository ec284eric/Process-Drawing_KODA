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

  DrawResizerScaleUpdated(this.details);
}

class DrawRotatorScaleUpdated extends DrawEvent {
  final ScaleUpdateDetails details;

  DrawRotatorScaleUpdated(this.details);
}
