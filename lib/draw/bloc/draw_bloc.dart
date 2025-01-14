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
  }

  void _drawingIconPresed(DrawingIconPresed event, Emitter<DrawState> emit) {
    emit(state.copyWith(
      drawingLocked: !state.drawingLocked,
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
    final modifiableImages = [
      ...state.modifiableImages,
    ];
    var rotation = state.rotation + event.details.rotation;

    if ((rotation - state.rotation).abs() > 0) {
      modifiableImages[event.index] = modifiableImages[event.index]?.copyWith(
        rotation: event.details.rotation,
      );
    }
    if (event.details.scale != 1) {
      modifiableImages[event.index] = modifiableImages[event.index]?.copyWith(
        scale: event.details.scale,
      );
      emit(state.copyWith(
        modifiableImages: modifiableImages,
      ));
    }
    modifiableImages[event.index] = modifiableImages[event.index]?.copyWith(
      offset: (state.modifiableImages[event.index]?.offset ?? Offset.zero) +
          event.details.focalPointDelta,
    );

    emit(state.copyWith(
      modifiableImages: modifiableImages,
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

  void _savePressed(DrawSavePressed event, Emitter<DrawState> emit) {
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
}
