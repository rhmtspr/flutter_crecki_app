import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  static const routeName = "/result";

  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      return const Scaffold(
        body: Center(child: Text("No result data available")),
      );
    }

    final String label = args["label"];
    final double confidence = args["confidence"];
    final String status = args["status"];
    final String recommendation = args["recommendation"];

    final Color statusColor = _getStatusColor(status);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text("Analysis Result"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildStatusCard(status, statusColor),
            const SizedBox(height: 20),
            _buildDetailCard(label, confidence),
            const SizedBox(height: 20),
            _buildRecommendationCard(recommendation),
            const Spacer(),
            _buildBackButton(context),
          ],
        ),
      ),
    );
  }

  // ================= UI COMPONENTS =================

  Widget _buildStatusCard(String status, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(_getStatusIcon(status), size: 50, color: color),
          const SizedBox(height: 10),
          Text(
            status,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String label, double confidence) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Detection Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildRow("Type", label),
          const SizedBox(height: 8),
          _buildRow("Confidence", "${(confidence * 100).toStringAsFixed(2)}%"),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(String recommendation) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Text(recommendation, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text("Back to Home"),
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  // ================= HELPERS =================

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "safe":
        return Colors.green;
      case "minor crack":
        return Colors.orange;
      case "severe crack":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case "safe":
        return Icons.check_circle;
      case "minor crack":
        return Icons.warning_amber_rounded;
      case "severe crack":
        return Icons.error;
      default:
        return Icons.help;
    }
  }
}
