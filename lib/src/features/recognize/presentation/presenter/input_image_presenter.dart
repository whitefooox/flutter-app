import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as image_lib;
import 'package:search3/src/features/recognize/domain/entities/input_image.dart';
import 'package:search3/src/features/recognize/presentation/presenter/image_utils.dart';

class InputImagePresenter {
  static image_lib.Image _getImage(String path) {
    final imageData = File(path).readAsBytesSync();
    image_lib.Image image = image_lib.decodeImage(imageData)!;
    return image;
  }

  static ByteBuffer _getPixels(image_lib.Image image) {
    final intList = List<int>.empty(growable: true);
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        intList.add(pixel.r.toInt());
        intList.add(pixel.g.toInt());
        intList.add(pixel.b.toInt());
      }
    }
    ByteBuffer buffer = Uint8List.fromList(intList).buffer;
    return buffer;
  }

  static image_lib.Image _resizeImage(
      image_lib.Image image, int width, int height) {
    return image_lib.copyResize(
      image,
      width: width,
      height: height,
    );
  }

  static InputImage fromPath(String path) {
    var image = _getImage(path);
    image = _resizeImage(image, 224, 224);
    return InputImage(_getPixels(image));
  }

  static InputImage fromCameraImage(CameraImage cameraImage) {
    var image = ImageUtils.convertCameraImage(cameraImage);
    image = _resizeImage(image, 224, 224);
    if (Platform.isAndroid) {
      image = image_lib.copyRotate(image, angle: 90);
    }
    return InputImage(_getPixels(image));
  }
}
