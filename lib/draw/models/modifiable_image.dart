import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'modifiable_image.freezed.dart';

@freezed
class ModifiableImage with _$ModifiableImage {
  const factory ModifiableImage({
    String? src,
    Uint8List? imageBytes,
    @Default(0) double rotation,
    @Default(1) double scale,
    @Default(Offset(0, 0)) Offset offset,
    Size? originalSize,
  }) = _ModifiableImage;
}
