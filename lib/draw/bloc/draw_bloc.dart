import 'package:bloc/bloc.dart';
import './bloc.dart';

class DrawBloc extends Bloc<DrawEvent, DrawState> {
  DrawBloc({
    required DrawState initialState,
  }) : super(initialState) {
    on<DrawDrawingChanged>(_drawingChanged);
    on<DrawColorChanged>(_colorChanged);
    on<DrawResizerScaleUpdated>(_resizerScaleUpdated);
    on<DrawRotatorScaleUpdated>(_rotatorScaleUpdated);
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

  void _rotatorScaleUpdated(
      DrawRotatorScaleUpdated event, Emitter<DrawState> emit) {
    var rotation = state.rotation + event.details.rotation;
    print(rotation - state.rotation);
    if ((rotation - state.rotation).abs() > .1) {
      emit(state.copyWith(
        rotation: event.details.rotation,
        // size: state.size + event.details.focalPointDelta,
      ));
    }
    emit(state.copyWith(
      size: state.size + event.details.focalPointDelta,
    ));
  }
}
