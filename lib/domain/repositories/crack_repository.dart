import 'dart:io';
import 'package:flutter_cracky_app/domain/entities/crack_result.dart';

abstract class CrackRepository {
  Future<CrackResult> analyzeImage(File image);
}
