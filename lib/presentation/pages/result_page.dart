import 'package:flutter/material.dart';
import 'package:flutter_cracky_app/domain/entities/crack_result.dart';
import 'package:flutter_cracky_app/presentation/widgets/detail_card.dart';
import 'package:flutter_cracky_app/presentation/widgets/recomendation_card.dart';
import 'package:flutter_cracky_app/presentation/widgets/status_card.dart';

class ResultPage extends StatelessWidget {
  static const routeName = "/result";

  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final result = args?["result"] as CrackResult?;
    final imagePath = args?["imagePath"] as String;

    if (result is! CrackResult) {
      return const Scaffold(
        body: Center(child: Text("No result data available")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Hasil Prediksi"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            StatusCard(status: result.status, imagePath: imagePath),
            const SizedBox(height: 20),
            DetailCard(label: result.label, confidence: result.confidence),
            const SizedBox(height: 20),
            RecommendationCard(recommendation: result.recommendation),
          ],
        ),
      ),
    );
  }
}
