import 'dart:ui' as ui;

import 'package:bloc/bloc.dart';
import 'package:drawing_app/draw/draw.dart';
import 'package:drawing_app/models/models.dart';
import 'package:flutter/material.dart';

import 'package:gal/gal.dart';

class DrawBloc extends Bloc<DrawEvent, DrawState> {
  DrawBloc({
    required DrawState initialState,
  }) : super(initialState) {
    on<DrawDrawingChanged>(_drawingChanged);
    on<DrawColorChanged>(_colorChanged);
    on<DrawResizerScaleUpdated>(_resizerScaleUpdated);
    on<DrawImageScaleUpdated>(_imageScaleUpdated);
    on<DrawLockPressed>(_lockPressed);
    on<DrawFirstImageSelected>(_firstImageSelected);
    on<DrawSecondImageSelected>(_secondImageSelected);
    on<DrawSavePressed>(_savePressed);
    on<DrawDrawingNameChanged>(_drawingNameChanged);
    on<DrawImageProcessed>(_imageProcessed);
    on<DrawHideMontageIconButtonPressed>(_hideMontageIconButtonPressed);
    on<DrawIconPresed>(_drawingIconPresed);
    on<DrawImageFlippedIconButtonPressed>(_imageFlippedIconPressed);
    on<DrawPenSelectorButtonPressed>(_penSelectorIconButtonPressed);
    on<DrawPencilIconButtonPressed>(_pencilIconPressed);
    on<DrawBrushIconButtonPressed>(_brushIconPressed);
    on<DrawRestartButtonPressed>(_restartPressed);
    on<DrawFlippedButtonPressed>(_drawingFlipped);
    on<DrawReflectedImageScaleUpdated>(_reflectedImageScaleUpdated);
    on<DrawImageProcessOpened>(_imageProcessOpened);
    on<DrawGestureEnded>(_onGestureEnded);
    on<DrawModifiableImagesCleared>(_clearModifiableImages);
    on<DrawModifiableImagesRestored>(_restoreModifiableImages);
    on<DrawSecondMontageDeleted>(_secondMontageDeleted);
    on<DrawToggleSwitchPressed>(_toggleSwitchPressed);
    on<DrawWhiteBackgroundSaved>(_whiteBackgroundSaved);
    on<DrawZoomChanged>(_drawingZoomChanged);
    on<DrawLinkIconButtonPressed>(_linkPressed);
  }

  void _penSelectorIconButtonPressed(
      DrawPenSelectorButtonPressed event, Emitter<DrawState> emit) {
    final opening = !state.penSelector;

    emit(state.copyWith(
      penSelector: opening,
      canDraw: (state.pencilSelected || state.brushSelected) && opening,
    ));
  }

  void _pencilIconPressed(
      DrawPencilIconButtonPressed event, Emitter<DrawState> emit) {
    const base = 2.7;

    emit(state.copyWith(
      color: const Color.fromARGB(255, 58, 61, 59),
      pencilSelected: true,
      brushSelected: false,
      penSelector: false,
      canDraw: true,
      strokeWidth: base,
      baseStrokeWidth: base,
    ));
  }

  void _brushIconPressed(
      DrawBrushIconButtonPressed event, Emitter<DrawState> emit) {
    const base = 4.0;
    final zoom = state.scale;

    emit(state.copyWith(
      color: const Color(0xff000000),
      brushSelected: true,
      pencilSelected: false,
      penSelector: false,
      canDraw: true,
      strokeWidth: base,
      baseStrokeWidth: base / (zoom * 0.7),
    ));
  }

  void _imageFlippedIconPressed(
      DrawImageFlippedIconButtonPressed event, Emitter<DrawState> emit) {
    final modifiableImages =
        List<ModifiableImage?>.from(state.modifiableImages);

    while (modifiableImages.length < 2) {
      modifiableImages.add(null);
    }

    if (modifiableImages[1] == null && modifiableImages[0] != null) {
      modifiableImages[1] = modifiableImages[0]!.copyWith(
        offset: modifiableImages[0]!.offset,
        scale: modifiableImages[0]!.scale,
        rotation: modifiableImages[0]!.rotation,
      );
    }

    emit(state.copyWith(
      modifiableImages: modifiableImages,
      imageFlipped: !state.imageFlipped,
      trashEnabled: true,
    ));
  }

  void _drawingIconPresed(DrawIconPresed event, Emitter<DrawState> emit) {
    emit(state.copyWith(
      newDrawingSelected: !state.newDrawingSelected,
    ));
  }

  void _hideMontageIconButtonPressed(
      DrawHideMontageIconButtonPressed event, Emitter<DrawState> emit) {
    emit(state.copyWith(
      hideMontage: !state.hideMontage,
    ));
  }

  void _drawingChanged(DrawDrawingChanged event, Emitter<DrawState> emit) {
    emit(state.copyWith(
      canUndo: event.canUndo,
      canRedo: event.canRedo,
    ));
  }

  void _colorChanged(DrawColorChanged event, Emitter<DrawState> emit) {
    emit(state.copyWith(
      color: event.color,
    ));
  }

  void _resizerScaleUpdated(
      DrawResizerScaleUpdated event, Emitter<DrawState> emit) {
    emit(state.copyWith(
      size: state.size + event.details.focalPointDelta,
    ));
  }

  void _imageScaleUpdated(
    DrawImageScaleUpdated event,
    Emitter<DrawState> emit,
  ) {
    final modifiableImages = [...state.modifiableImages];
    final currentImage = modifiableImages[event.index];
    if (currentImage == null) return;

    final gestureStart = state.gestureRotationStart;
    final currentGestureRotation = event.details.rotation;
    final currentImageRotation = currentImage.rotation;

    const rotationThreshold = 0.1;
    double? newRotation = currentImageRotation;

    if (gestureStart == null) {
      emit(state.copyWith(
        gestureRotationStart: currentGestureRotation,
        previousRotation: currentImageRotation,
      ));
      return;
    } else {
      final rotationDelta = currentGestureRotation - gestureStart;

      if (rotationDelta.abs() >= rotationThreshold) {
        final scaledRotationDelta = rotationDelta * 0.01;
        newRotation =
            (state.previousRotation + scaledRotationDelta).clamp(-180.0, 180.0);
      }
    }

    double? newScale;
    if (event.details.scale != 1.0 && event.index == 0) {
      final currentScale = currentImage.scale;
      const zoomSensitivity = 0.05;
      final deltaScale = (event.details.scale - 1) * zoomSensitivity;
      newScale = (currentScale + deltaScale).clamp(0.25, 3.0);
    }

    final newOffset = currentImage.offset + event.details.focalPointDelta;

    modifiableImages[event.index] = currentImage.copyWith(
      rotation: newRotation,
      scale: newScale ?? currentImage.scale,
      offset: newOffset,
    );

    emit(state.copyWith(
      modifiableImages: modifiableImages,
      previousRotation: newRotation,
      previousScale: newScale ?? currentImage.scale,
    ));
  }

  void _onGestureEnded(DrawGestureEnded event, Emitter<DrawState> emit) {
    final currentImageRotation =
        state.modifiableImages[event.index]?.rotation ?? 0.0;

    emit(state.copyWith(
      previousRotation: currentImageRotation,
      gestureRotationStart: null,
      gestureOffset:
          (state.modifiableImages[event.index]?.offset ?? Offset.zero),
    ));
  }

  void _lockPressed(DrawLockPressed event, Emitter<DrawState> emit) {
    final newLocked = !state.locked;

    emit(state.copyWith(
      locked: newLocked,
      trashEnabled: false,
    ));
  }

  void _firstImageSelected(
      DrawFirstImageSelected event, Emitter<DrawState> emit) {
    final modifiableImages = [...(state.modifiableImages)];

    if (state.modifiableImages.isNotEmpty) {
      modifiableImages[0] = modifiableImages[0]?.copyWith(
            src: event.image,
          ) ??
          ModifiableImage(
            src: event.image,
          );
    } else {
      modifiableImages.add(ModifiableImage(
        src: event.image,
      ));
    }
    emit(state.copyWith(
      modifiableImages: modifiableImages,
      selectedIndex: event.index,
    ));
  }

  void _secondImageSelected(
      DrawSecondImageSelected event, Emitter<DrawState> emit) {
    final modifiableImages = [...(state.modifiableImages)];
    if (state.modifiableImages.length >= 2) {
      modifiableImages[1] = modifiableImages[1]?.copyWith(
        src: event.image,
      );
    } else {
      if (modifiableImages.isEmpty) {
        modifiableImages.add(null);
      }
      modifiableImages.add(ModifiableImage(
        src: event.image,
      ));
    }
    emit(state.copyWith(
      modifiableImages: modifiableImages,
    ));
  }

  void _savePressed(DrawSavePressed event, Emitter<DrawState> emit) async {
    emit(state.copyWith(
      requestStatus: RequestStatus.inProgress,
      hideMontage: !state.hideMontage,
    ));
  }

  Future<void> _imageProcessed(
      DrawImageProcessed event, Emitter<DrawState> emit) async {
    await Gal.putImageBytes(
      event.imageBytes,
      name: state.drawingName.value,
    );
    emit(state.copyWith(
      requestStatus: RequestStatus.success,
    ));
    emit(state.copyWith(
      requestStatus: RequestStatus.waiting,
    ));
  }

  void _drawingNameChanged(
      DrawDrawingNameChanged event, Emitter<DrawState> emit) {
    emit(state.copyWith.drawingName(
      value: event.value,
    ));
  }

  void _restartPressed(
      DrawRestartButtonPressed event, Emitter<DrawState> emit) {
    emit(state.copyWith(
      canUndo: false,
      canRedo: false,
      locked: false,
      hideMontage: false,
      imageFlipped: false,
      penSelector: false,
      pencilSelected: false,
      newDrawingSelected: false,
      brushSelected: false,
      drawingFlipped: false,
      canDraw: false,
      isToggled: false,
      isLinked: false,
      showBackground: false,
      trashEnabled: false,
      color: Colors.black,
      strokeWidth: 8.0,
      baseStrokeWidth: 8.0,
      size: const Size.square((300)),
      rotation: 0.0,
      previousRotation: 0.0,
      scale: 1.0,
      previousScale: 1.0,
      gestureOffset: Offset.zero,
      gestureRotationStart: null,
      modifiableImages: [],
      drawingName: state.drawingName.copyWith(
        value: '',
        error: '',
        errorType: ErrorType.none,
      ),
      requestStatus: RequestStatus.waiting,
      // reflectedImage: const ModifiableImage(),
      reflectedImage: const ModifiableImage(
        scale: 1.0,
        offset: Offset.zero,
        rotation: 0.0,
      ),
      imageCollectRequestStatus: RequestStatus.waiting,
    ));
  }

  void _imageProcessOpened(
      DrawImageProcessOpened event, Emitter<DrawState> emit) {
    emit(state.copyWith(
      imageCollectRequestStatus:
          event.open ? RequestStatus.inProgress : RequestStatus.success,
    ));
  }

  // Future<void> _drawingFlipped(
  //     DrawFlippedButtonPressed event, Emitter<DrawState> emit) async {
  //   emit(state.copyWith(
  //     imageCollectRequestStatus: RequestStatus.inProgress,
  //   ));

  //   // await Future.delayed(const Duration(milliseconds: 10));
  //   // final modifiableImages = [...state.modifiableImages];
  //   // emit(state.copyWith(
  //   //   modifiableImages: [],
  //   // ));
  //   // await Future.delayed(const Duration(milliseconds: 10));
  //   final byteData =
  //       (await event.controller.getSurfaceImageData())?.buffer.asUint8List();

  //   if (byteData == null) {
  //     emit(state.copyWith(
  //       imageCollectRequestStatus: RequestStatus.failure,
  //     ));
  //     return;
  //   }

  //   final imageBytes = byteData.buffer.asUint8List();

  //   emit(state.copyWith(
  //     reflectedImage: state.reflectedImage.copyWith(
  //       imageBytes: imageBytes,
  //     ),
  //     drawingFlipped: !state.drawingFlipped,
  //     canDraw: !state.drawingFlipped,
  //     imageCollectRequestStatus: RequestStatus.success,
  //     // modifiableImages: modifiableImages,
  //   ));
  // }

  Future<void> _drawingFlipped(
      DrawFlippedButtonPressed event, Emitter<DrawState> emit) async {
    emit(state.copyWith(
      imageCollectRequestStatus: RequestStatus.inProgress,
    ));

    await Future.delayed(const Duration(milliseconds: 10));

    final byteData =
        (await event.controller.getSurfaceImageData())?.buffer.asUint8List();

    if (byteData == null) {
      emit(state.copyWith(
        imageCollectRequestStatus: RequestStatus.failure,
      ));
      return;
    }

    // final imageBytes = byteData.buffer.asUint8List();

    emit(state.copyWith(
      reflectedImage: state.reflectedImage.copyWith(
        imageBytes: byteData,
      ),
      drawingFlipped: !state.drawingFlipped,
      canDraw: !state.drawingFlipped,
      imageCollectRequestStatus: RequestStatus.success,
    ));
  }

  void _reflectedImageScaleUpdated(
      DrawReflectedImageScaleUpdated event, Emitter<DrawState> emit) {
    var modifiableImage = state.reflectedImage;

    double? newScale;
    if (event.details.scale != 1.0) {
      final currentScale = modifiableImage.scale;
      const zoomSensitivity = 0.08;
      final deltaScale = (event.details.scale - 1) * zoomSensitivity;
      newScale = (currentScale + deltaScale).clamp(0.3, 6.0);
    }

    modifiableImage = modifiableImage.copyWith(
      scale: newScale ?? modifiableImage.scale,
      offset: modifiableImage.offset + event.details.focalPointDelta,
    );

    emit(state.copyWith(
      reflectedImage: modifiableImage,
    ));
  }

  void _clearModifiableImages(
      DrawModifiableImagesCleared event, Emitter<DrawState> emit) {
    emit(state.copyWith(
      modifiableImages: [],
    ));
  }

  void _restoreModifiableImages(
      DrawModifiableImagesRestored event, Emitter<DrawState> emit) {
    emit(state.copyWith(
      modifiableImages: event.images,
    ));
  }

  void _secondMontageDeleted(
      DrawSecondMontageDeleted event, Emitter<DrawState> emit) {
    if (state.modifiableImages.length == 2) {
      final updatedImages = List.of(state.modifiableImages)..removeLast();
      emit(state.copyWith(
        modifiableImages: updatedImages,
        locked: false,
        imageFlipped: false,
        previousRotation: 0.0,
        hideMontage: false,
      ));
    }
  }

  void _toggleSwitchPressed(
      DrawToggleSwitchPressed event, Emitter<DrawState> emit) {
    final toggled = !state.isToggled;
    emit(state.copyWith(
      isToggled: toggled,
      showBackground: !toggled,
    ));
  }

  Future<void> _whiteBackgroundSaved(
    DrawWhiteBackgroundSaved event,
    Emitter<DrawState> emit,
  ) async {
    final controller = event.controller;
    final state = this.state;

    const int width = 2048;
    const int height = 1536;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final backgroundPaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
        backgroundPaint);

    final byteData = await controller.getImageData();
    if (byteData == null) {
      event.onExported(null);
      return;
    }

    final imageBytes = byteData.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();
    final drawingImage = frame.image;

    final dx = (width - drawingImage.width) / 2;
    final dy = (height - drawingImage.height) / 2;
    final offset = Offset(dx, dy);

    canvas.drawImage(drawingImage, offset, Paint());

    if (state.drawingFlipped) {
      canvas.save();
      canvas.translate(width.toDouble(), 0);

      canvas.scale(-1, 1);
      canvas.drawImage(drawingImage, offset, Paint());
      canvas.restore();
    }

    final composedImage = await recorder.endRecording().toImage(width, height);
    final pngBytes =
        await composedImage.toByteData(format: ui.ImageByteFormat.png);

    event.onExported(pngBytes?.buffer.asUint8List());
  }

  void _drawingZoomChanged(DrawZoomChanged event, Emitter<DrawState> emit) {
    final zoom = event.zoom.clamp(0.1, 10.0);
    final base = state.baseStrokeWidth;

    double adjusted = base;

    if (state.pencilSelected) {
      adjusted = base;
    } else if (state.brushSelected) {
      final zoomFactor = (zoom * 0.7).clamp(0.1, double.infinity);
      adjusted = base / zoomFactor;
      adjusted = adjusted.clamp(0.5, 50.0);
    }

    emit(state.copyWith(
      scale: zoom,
      strokeWidth: adjusted,
    ));
  }

  void _linkPressed(DrawLinkIconButtonPressed event, Emitter<DrawState> emit) {
    emit(state.copyWith(
      isLinked: !state.isLinked,
    ));
  }
}
