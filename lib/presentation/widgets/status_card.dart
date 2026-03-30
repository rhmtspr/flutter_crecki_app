import 'dart:io';

import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final String status;
  final String imagePath;

  const StatusCard({super.key, required this.status, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 180,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(File(imagePath), fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.black.withValues(alpha: 0.2),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_getStatusIcon(status), size: 50, color: color),
                  const SizedBox(height: 16),
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
            ),
          ],
        ),
      ),
    );

    // return Container(
    //   width: double.infinity,
    //   padding: const EdgeInsets.all(20),
    //   decoration: BoxDecoration(
    //     color: color.withValues(alpha: 0.1),
    //     borderRadius: BorderRadius.circular(16),
    //   ),
    //   child: Column(
    //     children: [
    //       Icon(_getStatusIcon(status), size: 50, color: color),
    //       const SizedBox(height: 10),
    //       Text(
    //         status,
    //         style: Theme.of(context).textTheme.titleLarge?.copyWith(
    //           fontWeight: FontWeight.bold,
    //           color: color,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
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
