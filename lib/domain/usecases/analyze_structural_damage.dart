import 'dart:io';

import 'package:flutter_cracky_app/domain/entities/crack_result.dart';
import 'package:flutter_cracky_app/domain/repositories/crack_repository.dart';

class AnalyzeStructuralDamage {
  final CrackRepository repository;

  AnalyzeStructuralDamage(this.repository);

  Future<CrackResult> call(File image) {
    return repository.analyzeImage(image);
  }
}
