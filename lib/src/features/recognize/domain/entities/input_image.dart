import 'dart:typed_data';

class InputImage {
  final ByteBuffer buffer;
  final int width;
  final int height;

  InputImage({required this.buffer, required this.width, required this.height});
}
