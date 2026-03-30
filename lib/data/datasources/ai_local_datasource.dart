import "dart:io";
import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:tflite_flutter/tflite_flutter.dart";
import "package:image/image.dart" as img;

class AiLocalDatasource {
  Interpreter? _interpreter;
  List<String>? _labels;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset("assets/cracki_model.tflite");
      final labelData = await rootBundle.loadString("assets/labels.txt");
      _labels = labelData.split('\n');
      debugPrint("Model dan label telah dimuat dengan sukses");
    } catch (e) {
      debugPrint("");
      throw Exception("Gagal memuat model");
    }
  }

  Future<Map<String, dynamic>> runInference(File imageFile) async {
    if (_interpreter == null) throw Exception("interpreter not initialized");

    final imageData = await imageFile.readAsBytes();
    img.Image? originalImage = img.decodeImage(imageData);
    img.Image resizedImage = img.copyResize(
      originalImage!,
      width: 224,
      height: 224,
    );

    var input = _imageToByteListFloat32(resizedImage, 224);

    var output = List.filled(1 * 3, 0.0).reshape([1, 3]);

    _interpreter!.run(input, output);
    int classIndex = -1;
    double highScoringProb = 0.0;

    for (int i = 0; i < output[0].length; i++) {
      if (output[0][i] > highScoringProb) {
        highScoringProb = output[0][i];
        classIndex = i;
      }
    }

    return {"label": _labels![classIndex], "confidence": highScoringProb};
  }

  Uint8List _imageToByteListFloat32(img.Image image, int inputSize) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var y = 0; y < inputSize; y++) {
      for (var x = 0; x < inputSize; x++) {
        var pixel = image.getPixel(x, y);
        buffer[pixelIndex++] = pixel.r / 255.0;
        buffer[pixelIndex++] = pixel.g / 255.0;
        buffer[pixelIndex++] = pixel.b / 255.0;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  void close() {
    _interpreter?.close();
  }
}
