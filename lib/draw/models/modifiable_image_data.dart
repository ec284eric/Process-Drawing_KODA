import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'modifiable_image_data.freezed.dart';

@freezed
class ModifiableImageData with _$ModifiableImageData {
  const factory ModifiableImageData({
    Uint8List? src,
    @Default(0) double rotation,
    @Default(1) double scale,
    @Default(Offset(0, 0)) Offset offset,
  }) = _ModifiableImageData;
}
