import "dart:io";
import "package:flutter_cracky_app/domain/entities/crack_result.dart";
import "package:flutter_cracky_app/domain/repositories/crack_repository.dart";
import "package:flutter_cracky_app/data/datasources/ai_local_datasource.dart";
import "package:flutter_cracky_app/core/utils/image_processor.dart";

class CrackRepositoryImpl implements CrackRepository {
  final AiLocalDataSource dataSource;

  CrackRepositoryImpl(this.dataSource);

  @override
  Future<CrackResult> analyzeImage(File image) async {
    final input = ImageProcessor.process(image);
    final output = dataSource.runModel(input);

    final labels = ["Safe", "Minor Crack", "Severe Crack"];

    int maxIndex = 0;
    double maxScore = output[0];

    for (int i = 1; i < output.length; i++) {
      if (output[i] > maxScore) {
        maxScore = output[i];
        maxIndex = i;
      }
    }

    return CrackResult(status: labels[maxIndex], confidence: maxScore);
  }
}
