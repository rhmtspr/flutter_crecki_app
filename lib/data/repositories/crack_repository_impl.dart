import "dart:io";

import "package:flutter_cracky_app/data/datasources/ai_local_datasource.dart";
import "package:flutter_cracky_app/domain/entities/crack_result.dart";
import "package:flutter_cracky_app/domain/repositories/crack_repository.dart";

class CrackRepositoryImpl implements CrackRepository {
  final AiLocalDatasource localDatasource;

  CrackRepositoryImpl({required this.localDatasource});

  @override
  Future<CrackResult> detectCrack(File imageFile) async {
    try {
      final rawResult = await localDatasource.runInference(imageFile);
      final String label = rawResult["label"];
      final double confidence = rawResult["confidence"];
      return _mapToEntity(label, confidence);
    } catch (e) {
      throw Exception("Failed to analyze image: $e");
    }
  }

  CrackResult _mapToEntity(String label, double confidence) {
    if (label == "Multibranced Crack") {
      return CrackResult(
        label: label,
        confidence: confidence,
        status: "DANGER",
        recommendation:
            "Structural damage detected. Please evacuate and consult an expert.",
      );
    } else if (label == "Multibranced Crack") {
      return CrackResult(
        label: label,
        confidence: confidence,
        status: "DANGER",
        recommendation:
            "Structural damage detected. Please evacuate and consult an expert.",
      );
    } else {
      return CrackResult(
        label: label,
        confidence: confidence,
        status: "DANGER",
        recommendation:
            "Structural damage detected. Please evacuate and consult an expert.",
      );
    }
  }
}
