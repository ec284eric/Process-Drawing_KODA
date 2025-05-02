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
    on<HideMontagePressed>(_hideMontagePressed);
    on<DrawingIconPresed>(_drawingIconPresed);
    on<ImageFlippedIconPressed>(_imageFlippedIconPressed);
    on<PenSelectorPressed>(_penSelectorPressed);
    on<PenIconPressed>(_penIconPressed);
    on<BrushIconPressed>(_brushIconPressed);
    on<DrawRestartPressed>(_restartPressed);
    on<DrawingFlippedPressed>(_drawingFlipped);
    on<DrawReflectedImageScaleUpdated>(_reflectedImageScaleUpdated);
    on<DrawPaintedImageCollected>(_paintedImageCollected);
    on<DrawImageProcessOpened>(_imageProcessOpened);
    on<DrawGestureEnded>(_onGestureEnded);
    on<DrawClearModifiableImages>(_clearModifiableImages);
    on<DrawRestoreModifiableImages>(_restoreModifiableImages);
  }

  void _penSelectorPressed(PenSelectorPressed event, Emitter<DrawState> emit) {
    emit(
      state.copyWith(
        penSelector: !state.penSelector,
      ),
    );
  }

  void _penIconPressed(PenIconPressed event, Emitter<DrawState> emit) {
    emit(
      state.copyWith(
        // color: const Color.fromARGB(255, 41, 43, 42),
        color: const Color.fromARGB(255, 58, 61, 59),
        pencilSelected: true,
        brushSelected: false,
        penSelector: !state.penSelector,
        strokeWidth: 1.5,
      ),
    );
  }

  void _brushIconPressed(BrushIconPressed event, Emitter<DrawState> emit) {
    emit(
      state.copyWith(
        color: const Color(0xff000000),
        brushSelected: true,
        pencilSelected: false,
        penSelector: !state.penSelector,
        strokeWidth: 8.0,
      ),
    );
  }

  void _imageFlippedIconPressed(
      ImageFlippedIconPressed event, Emitter<DrawState> emit) {
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
    ));
  }

  void _drawingIconPresed(DrawingIconPresed event, Emitter<DrawState> emit) {
    emit(state.copyWith(
      newDrawingSelected: !state.newDrawingSelected,
    ));
  }

  void _hideMontagePressed(HideMontagePressed event, Emitter<DrawState> emit) {
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
      DrawImageScaleUpdated event, Emitter<DrawState> emit) {
    if (state.locked) return;

    final modifiableImages = [...state.modifiableImages];
    final currentImage = modifiableImages[event.index];
    if (currentImage == null) return;

    final gestureStart = state.gestureRotationStart;
    final currentGestureRotation = event.details.rotation;
    final currentImageRotation = currentImage.rotation;

    double? newRotation;
    if (gestureStart == null) {
      emit(state.copyWith(
        gestureRotationStart: currentGestureRotation,
        previousRotation: currentImageRotation,
      ));
      return;
    } else {
      final rotationDelta = (currentGestureRotation - gestureStart) * 0.2;
      newRotation =
          (state.previousRotation + rotationDelta).clamp(-180.0, 180.0);
    }

    double? newScale;
    if (event.details.scale != 1.0 && event.index == 0) {
      final currentScale = currentImage.scale;
      const zoomSensitivity = 0.08;
      final deltaScale = (event.details.scale - 1) * zoomSensitivity;
      newScale = (currentScale + deltaScale).clamp(0.3, 6.0);
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
      selectedIndex: event.index,
    ));
  }

  void _onGestureEnded(DrawGestureEnded event, Emitter<DrawState> emit) {
    if (state.locked) return;

    final currentImageRotation =
        state.modifiableImages[event.index]?.rotation ?? 0.0;

    emit(state.copyWith(
      previousRotation: currentImageRotation,
      gestureRotationStart: null,
      gestureOffset:
          (state.modifiableImages[event.index]?.offset ?? Offset.zero),
    ));
    emit(state.copyWith(
      selectedIndex: event.index,
    ));
  }

  void _lockPressed(DrawLockPressed event, Emitter<DrawState> emit) {
    emit(state.copyWith(
      locked: !state.locked,
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

  void _restartPressed(DrawRestartPressed event, Emitter<DrawState> emit) {
    emit(state.copyWith(
      canUndo: false,
      canRedo: false,
      locked: false,
      hideMontage: false,
      imageFlipped: false,
      penSelector: false,
      pencilSelected: false,
      newDrawingSelected: false,
      brushSelected: true,
      drawingFlipped: false,
      color: Colors.black,
      strokeWidth: 8.0,
      size: const Size.square((300)),
      rotation: 0,
      scale: 1,
      selectedIndex: -1,
      modifiableImages: [],
      drawingName: state.drawingName.copyWith(
        value: '',
        error: '',
        errorType: ErrorType.none,
      ),
      requestStatus: RequestStatus.waiting,
      reflectedImage: const ModifiableImageData(),
      imageCollectRequestStatus: RequestStatus.waiting,
    ));
  }

  void _paintedImageCollected(
      DrawPaintedImageCollected event, Emitter<DrawState> emit) {
    emit(state.copyWith.reflectedImage(
      src: event.image,
    ));
  }

  void _drawingFlipped(DrawingFlippedPressed event, Emitter<DrawState> emit) {
    emit(
      state.copyWith(
        drawingFlipped: !state.drawingFlipped,
      ),
    );
  }

  void _reflectedImageScaleUpdated(
      DrawReflectedImageScaleUpdated event, Emitter<DrawState> emit) {
    var modifiableImage = state.reflectedImage;
    var rotation = state.rotation + event.details.rotation;

    if ((rotation - state.rotation).abs() > 0) {
      modifiableImage = modifiableImage.copyWith(
        rotation: event.details.rotation,
      );
    }

    modifiableImage = modifiableImage.copyWith(
      offset: (state.reflectedImage.offset) + event.details.focalPointDelta,
    );
    emit(state.copyWith(
      reflectedImage: modifiableImage,
    ));
  }

  void _imageProcessOpened(
      DrawImageProcessOpened event, Emitter<DrawState> emit) {
    emit(state.copyWith(
      imageCollectRequestStatus:
          event.open ? RequestStatus.inProgress : RequestStatus.success,
    ));
  }

  void _clearModifiableImages(
      DrawClearModifiableImages event, Emitter<DrawState> emit) {
    emit(state.copyWith(
      modifiableImages: [],
    ));
  }

  void _restoreModifiableImages(
      DrawRestoreModifiableImages event, Emitter<DrawState> emit) {
    emit(state.copyWith(modifiableImages: event.images));
  }
}
