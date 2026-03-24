import 'dart:io';
import 'package:image/image.dart' as img;

class ImageProcessor {
  static List<List<List<List<double>>>> process(File file) {
    final image = img.decodeImage(file.readAsBytesSync())!;
    final resized = img.copyResize(image, width: 224, height: 224);

    List<List<List<double>>> input = List.generate(
      224,
      (y) => List.generate(224, (x) {
        final pixel = resized.getPixel(x, y);
        return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
      }),
    );

    return [input]; // shape: [1, 224, 224, 3]
  }
}
