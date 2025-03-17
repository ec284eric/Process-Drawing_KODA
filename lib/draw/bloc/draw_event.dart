import 'dart:typed_data';

import 'package:flutter/material.dart';

sealed class DrawEvent {
  const DrawEvent();
}

class PenSelectorPressed extends DrawEvent {
  const PenSelectorPressed();
}

class DrawingIconPresed extends DrawEvent {
  const DrawingIconPresed();
}

class PenIconPressed extends DrawEvent {
  const PenIconPressed();
}

class BrushIconPressed extends DrawEvent {
  const BrushIconPressed();
}

class ImageFlippedIconPressed extends DrawEvent {
  const ImageFlippedIconPressed();
}

class HideMontagePressed extends DrawEvent {
  const HideMontagePressed();
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
  final int index;

  const DrawFirstImageSelected({
    required this.image,
    required this.index,
  });
}

class DrawSecondImageSelected extends DrawEvent {
  final String image;

  const DrawSecondImageSelected(this.image);
}

class DrawSavePressed extends DrawEvent {
  const DrawSavePressed();
}

class DrawImageProcessed extends DrawEvent {
  final Uint8List imageBytes;

  const DrawImageProcessed(this.imageBytes);
}

class DrawDrawingNameChanged extends DrawEvent {
  final String value;

  const DrawDrawingNameChanged(this.value);
}

class DrawRestartPressed extends DrawEvent {
  const DrawRestartPressed();
}

class DrawingFlippedPressed extends DrawEvent {
  const DrawingFlippedPressed();
}

class DrawPaintedImageCollected extends DrawEvent {
  final Uint8List image;

  const DrawPaintedImageCollected(this.image);
}

class DrawReflectedImageScaleUpdated extends DrawEvent {
  final ScaleUpdateDetails details;
  const DrawReflectedImageScaleUpdated(this.details);
}

class DrawImageProcessOpened extends DrawEvent {
  final bool open;

  const DrawImageProcessOpened(this.open);
}
