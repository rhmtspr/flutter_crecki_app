import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final String status;

  const StatusCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);

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
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case "aman":
      return Colors.green;
    case "peringatan":
      return Colors.orange;
    case "bahaya":
      return Colors.red;
    default:
      return Colors.grey;
  }
}

IconData _getStatusIcon(String status) {
  switch (status.toLowerCase()) {
    case "aman":
      return Icons.check_circle;
    case "peringatan":
      return Icons.warning_amber_rounded;
    case "bahaya":
      return Icons.error;
    default:
      return Icons.help;
  }
}
