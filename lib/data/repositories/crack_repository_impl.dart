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
      final String label = (rawResult["label"] as String).trim();
      final double confidence = rawResult["confidence"];
      return _mapToEntity(label, confidence);
    } catch (e) {
      throw Exception("Failed to analyze image: $e");
    }
  }

  CrackResult _mapToEntity(String label, double confidence) {
    if (label == "Multibranched Crack" || label == "Multibranced Crack") {
      return CrackResult(
        label: label,
        confidence: confidence,
        status: "BAHAYA",
        recommendation:
            "Terdeteksi kerusakan struktural. Silahkan mengevakuasi diri dan konsultasikan dengan ahli.",
      );
    } else if (label == "Simple Crack" || label == "Simple Cracks") {
      return CrackResult(
        label: label,
        confidence: confidence,
        status: "PERINGATAN",
        recommendation:
            "Terdeteksi retakan kecil. Pantau area tersebut dan pertimbangkan untuk segera melakukan perbaikan kecil.",
      );
    } else {
      return CrackResult(
        label: label,
        confidence: confidence,
        status: "AMAN",
        recommendation:
            "Tidak terdektesi adanya kerusakan yang signifikan. Cukup lakukan perawatan rutin.",
      );
    }
  }
}
