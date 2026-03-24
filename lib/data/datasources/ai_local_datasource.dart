import 'package:tflite_flutter/tflite_flutter.dart';

class AiLocalDataSource {
  late Interpreter _interpreter;

  Future<void> init() async {
    _interpreter = await Interpreter.fromAsset('assets/cracki_model.tflite');
  }

  List<double> runModel(List input) {
    final output = List.generate(1, (_) => List.filled(3, 0.0));

    _interpreter.run(input, output);

    return output[0];
  }
}
