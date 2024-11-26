import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'modifiable_image.freezed.dart';

@freezed
class ModifiableImage with _$ModifiableImage {
  const factory ModifiableImage({
    required String src,
    @Default(0) double rotation,
    @Default(1) double scale,
    @Default(Offset(0, 0)) Offset offset,
  }) = _ModifiableImage;
}
