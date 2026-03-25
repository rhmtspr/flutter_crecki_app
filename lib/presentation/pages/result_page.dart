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
    final result = ModalRoute.of(context)?.settings.arguments;

    if (result is CrackResult) {
      print("ResultPage label: ${result.label}");
      print("ResultPage status: ${result.status}");
    }

    if (result is! CrackResult) {
      return const Scaffold(
        body: Center(child: Text("No result data available")),
      );
    }

    // final theme = Theme.of(context);

    return Scaffold(
      // backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text("Analysis Result"),
        centerTitle: true,
        // elevation: 0,
        // backgroundColor: Colors.white,
        // foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            StatusCard(status: result.status),
            const SizedBox(height: 20),
            DetailCard(label: result.label, confidence: result.confidence),
            const SizedBox(height: 20),
            RecommendationCard(recommendation: result.recommendation),
            const Spacer(),
            _BackButton(),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("Back to Home"),
      ),
    );
  }
}
