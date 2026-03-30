import 'package:flutter/material.dart';
import 'package:flutter_cracky_app/presentation/widgets/card_container.dart';
import 'package:flutter_cracky_app/presentation/widgets/info_row.dart';

class DetailCard extends StatelessWidget {
  final String label;
  final double confidence;

  const DetailCard({super.key, required this.label, required this.confidence});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Informasi Detail",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          InfoRow(title: "Tipe", value: label),
          const SizedBox(height: 8),
          InfoRow(
            title: "Confidence",
            value: (confidence * 100).toStringAsFixed(2),
          ),
        ],
      ),
    );
  }
}
