import 'package:bloc/bloc.dart';
import './bloc.dart';

class DrawBloc extends Bloc<DrawEvent, DrawState> {
  DrawBloc({
    required DrawState initialState,
  }) : super(initialState) {
    on<DrawDrawingChanged>(_drawingChanged);
    on<DrawColorChanged>(_colorChanged);
    on<DrawResizerScaleUpdated>(_resizerScaleUpdated);
    on<DrawImageScaleUpdated>(_imageScaleUpdated);
    on<DrawLockPressed>(_lockPressed);
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
      modifiableImages[event.index] = modifiableImages[event.index].copyWith(
        rotation: event.details.rotation,
      );
    }
    modifiableImages[event.index] = modifiableImages[event.index].copyWith(
      scale: event.details.scale,
      offset: state.modifiableImages[event.index].offset +
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
}
