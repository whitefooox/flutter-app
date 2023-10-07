import 'dart:io';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as image_lib;
import 'package:search3/src/domain/entities/input_image.dart';
import 'package:search3/src/presentation/presenter/image_utils.dart';

class InputImagePresenter {
  static InputImage fromImage(image_lib.Image image) {
    image_lib.Image imageInput = image_lib.copyResize(
      image,
      width: 224,
      height: 224,
    );
    final imageMatrix = List.generate(
      imageInput.height,
      (y) => List.generate(
        imageInput.width,
        (x) {
          final pixel = imageInput.getPixel(x, y);
          return [pixel.r, pixel.g, pixel.b];
        },
      ),
    );
    return InputImage(imageMatrix);
  }

  static InputImage fromCameraImage(CameraImage cameraImage) {
    image_lib.Image? img = ImageUtils.convertCameraImage(cameraImage);
    image_lib.Image imageInput = image_lib.copyResize(
      img!,
      width: 224,
      height: 224,
    );
    if (Platform.isAndroid) {
      imageInput = image_lib.copyRotate(imageInput, angle: 90);
    }
    final imageMatrix = List.generate(
      imageInput.height,
      (y) => List.generate(
        imageInput.width,
        (x) {
          final pixel = imageInput.getPixel(x, y);
          return [pixel.r, pixel.g, pixel.b];
        },
      ),
    );
    return InputImage(imageMatrix);
  }
}
