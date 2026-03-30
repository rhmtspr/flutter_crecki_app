import 'package:flutter/material.dart';
import 'package:flutter_cracky_app/presentation/widgets/card_container.dart';

class RecommendationCard extends StatelessWidget {
  final String recommendation;

  const RecommendationCard({super.key, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      // color: Colors.blue.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Rekomendasi Tindakan",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(recommendation, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
