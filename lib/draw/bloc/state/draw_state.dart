import 'package:drawing_app/draw/models/models.dart';
import 'package:drawing_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'draw_state.freezed.dart';

@freezed
class DrawState with _$DrawState {
  const factory DrawState({
    @Default(false) bool canUndo,
    @Default(false) bool canRedo,
    @Default(false) bool locked,
    @Default(false) bool hideMontage,
    @Default(false) bool drawingLocked,
    @Default(Colors.black) Color color,
    @Default(Size.square(300)) Size size,
    @Default(0) double rotation,
    @Default(1) double scale,
    @Default([]) List<ModifiableImage?> modifiableImages,
    @Default(TextFieldInput()) TextFieldInput drawingName,
    @Default(RequestStatus.waiting) RequestStatus requestStatus,
  }) = _DrawState;
}
