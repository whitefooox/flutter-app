import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as image_lib;
import 'package:search3/src/features/recognize/domain/entities/input_image.dart';
import 'package:search3/src/features/recognize/presentation/presenter/image_utils.dart';

class InputImagePresenter {
  static image_lib.Image getImageFromPath(String path) {
    final imageData = File(path).readAsBytesSync();
    image_lib.Image image = image_lib.decodeImage(imageData)!;
    return image;
  }

  static image_lib.Image getImageFromCameraImage(CameraImage cameraImage) {
    return ImageUtils.convertCameraImage(cameraImage);
  }

  static ByteBuffer _getPixels(image_lib.Image image) {
    final intList = List<int>.empty(growable: true);
    for (var pixel in image) {
      intList.add(pixel.r.toInt());
      intList.add(pixel.g.toInt());
      intList.add(pixel.b.toInt());
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

  static InputImage _createFromImage(
      image_lib.Image image, int width, int height) {
    return InputImage(buffer: _getPixels(image), width: width, height: height);
  }

  static InputImage prepareImage(image_lib.Image image, int width, int height) {
    final resizedImage = _resizeImage(image, width, height);
    final inputImage = _createFromImage(resizedImage, width, height);
    return inputImage;
  }
}
