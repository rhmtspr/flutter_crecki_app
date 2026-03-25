class CrackResult {
  final String label;
  final double confidence;
  final String status;
  final String recommendation;

  CrackResult({
    required this.label,
    required this.confidence,
    required this.status,
    required this.recommendation,
  });
}
