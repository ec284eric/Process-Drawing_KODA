import 'dart:typed_data';

import 'package:drawing_app/draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';

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
  final double baseStrokeWidth;

  const PenIconPressed({
    required this.baseStrokeWidth,
  });
}

class BrushIconPressed extends DrawEvent {
  final double baseStrokeWidth;

  const BrushIconPressed({
    required this.baseStrokeWidth,
  });
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

  DrawColorChanged({
    required this.color,
  });
}

class DrawResizerScaleUpdated extends DrawEvent {
  final ScaleUpdateDetails details;

  const DrawResizerScaleUpdated({
    required this.details,
  });
}

class DrawImageScaleUpdated extends DrawEvent {
  final int index;
  final ScaleUpdateDetails details;

  const DrawImageScaleUpdated({
    required this.index,
    required this.details,
  });
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

  const DrawSecondImageSelected({
    required this.image,
  });
}

class DrawSavePressed extends DrawEvent {
  const DrawSavePressed();
}

class DrawImageProcessed extends DrawEvent {
  final Uint8List imageBytes;

  const DrawImageProcessed({
    required this.imageBytes,
  });
}

class DrawDrawingNameChanged extends DrawEvent {
  final String value;

  const DrawDrawingNameChanged({
    required this.value,
  });
}

class DrawRestartPressed extends DrawEvent {
  const DrawRestartPressed();
}

class DrawingFlippedPressed extends DrawEvent {
  const DrawingFlippedPressed();
}

class DrawPaintedImageCollected extends DrawEvent {
  final Uint8List image;

  const DrawPaintedImageCollected({
    required this.image,
  });
}

class DrawReflectedImageScaleUpdated extends DrawEvent {
  final ScaleUpdateDetails details;

  const DrawReflectedImageScaleUpdated({
    required this.details,
  });
}

class DrawImageProcessOpened extends DrawEvent {
  final bool open;

  const DrawImageProcessOpened({
    required this.open,
  });
}

class DrawGestureEnded extends DrawEvent {
  final int index;

  const DrawGestureEnded({
    required this.index,
  });
}

class DrawClearModifiableImages extends DrawEvent {
  const DrawClearModifiableImages();
}

class DrawRestoreModifiableImages extends DrawEvent {
  final List<ModifiableImage?> images;

  const DrawRestoreModifiableImages({
    required this.images,
  });
}

class DrawSecondMontageDeleted extends DrawEvent {
  const DrawSecondMontageDeleted();
}

class DrawToggleSwitchPressed extends DrawEvent {
  const DrawToggleSwitchPressed();
}

class DrawFlipPressed extends DrawEvent {
  final DrawingController controller;
  final BuildContext context;

  const DrawFlipPressed({
    required this.controller,
    required this.context,
  });
}

class ExportDrawingWithWhiteBackground extends DrawEvent {
  final DrawingController controller;
  final void Function(Uint8List?) onExported;

  const ExportDrawingWithWhiteBackground({
    required this.controller,
    required this.onExported,
  });
}

class DrawZoomChanged extends DrawEvent {
  final double zoom;

  const DrawZoomChanged({
    required this.zoom,
  });
}

class DrawToggleLinked extends DrawEvent {
  const DrawToggleLinked();
}
