import "dart:io";
import "dart:typed_data";
import "package:flutter/services.dart";
import "package:tflite_flutter/tflite_flutter.dart";
import "package:image/image.dart" as img;
import "package:flutter_vision/flutter_vision.dart";

class AiLocalDatasource {
  late FlutterVision vision;
  Interpreter? _interpreter;
  List<String>? _labels;

  // Future<void> loadModel() async {
  //   try {
  //     _interpreter = await Interpreter.fromAsset("assets/cracki_model.tflite");
  //     final labelData = await rootBundle.loadString("assets/labels.txt");
  //     _labels = labelData.split('\n');
  //     print("Model and labels loaded successfully");
  //   } catch (e) {
  //     print("Error loading model: $e");
  //   }
  // }

  Future<void> loadYoloModel() async {
    vision = FlutterVision();

    await vision.loadYoloModel(
      modelPath: "assets/best_float32.tflite",
      labels: "assets/label.txt",
      modelVersion: "yolov8",
      numThreads: 2,
      useGpu: true,
    );
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

  // void close() {
  //   _interpreter?.close();
  // }

  Future<Map<String, dynamic>> runYoloInference(File imageFile) async {
    final Uint8List bytes = await imageFile.readAsBytes();

    final img.Image? decodedImage = img.decodeImage(bytes);
    if (decodedImage == null) throw Exception("Could not decode image");

    final int width = decodedImage.width;
    final int height = decodedImage.height;

    return await analyzeImage(bytes, height, width);
  }

  Future<Map<String, dynamic>> analyzeImage(
    Uint8List bytes,
    int h,
    int w,
  ) async {
    final results = await vision.yoloOnImage(
      bytesList: bytes,
      imageHeight: h,
      imageWidth: w,
      iouThreshold: 0.4,
      confThreshold: 0.3,
      classThreshold: 0.5,
    );

    if (results.isEmpty) return {"score": 0, "status": "Safe"};

    int crackCount = results.length;
    double totalArea = 0;
    double maxIndivRatio = 0;

    for (var crack in results) {
      double boxWidth = crack["box"][2] - crack["box"][0];
      double boxHeight = crack["box"][3] - crack["box"][1];
      double area = (boxWidth * boxHeight) / (h * 2) * 100;

      totalArea += area;
      if (area > maxIndivRatio) maxIndivRatio = area;
    }

    double crowdingScore = (crackCount.clamp(0, 10) / 10) * 100;
    double intensityScore = totalArea * 5;
    double worstScore = maxIndivRatio * 3;

    double finalScore =
        (crowdingScore * 0.2) + (intensityScore * 0.3) + (worstScore * 0.5);
    finalScore = finalScore.clamp(0, 100);

    String status = "Safe";
    if (crackCount > 6 || worstScore > 60) {
      status = "Danger";
    } else if (finalScore > 35) {
      status = "Warning";
    }

    return {"score": finalScore, "status": status, "count": crackCount};
  }

  void close() {
    _interpreter?.close();
    vision.closeYoloModel();
  }
}
