import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'draw_state.freezed.dart';

@freezed
class DrawState with _$DrawState {
  const factory DrawState({
    @Default(false) bool canUndo,
    @Default(false) bool canRedo,
    @Default(Colors.black) Color color,
    @Default(Size.square(300)) Size size,
    @Default(0) double rotation,
  }) = _DrawState;
}
