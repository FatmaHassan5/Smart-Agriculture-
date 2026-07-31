import 'package:flutter/material.dart';
import '../models/prediction_model.dart';
import '../theme/app_theme.dart';

Color categoryColor(String category) {
  switch (category.toLowerCase()) {
    case "low":
      return AppColors.lowColor;
    case "medium":
      return AppColors.mediumColor;
    case "high":
      return AppColors.highColor;
    default:
      return Colors.blueGrey;
  }
}

IconData categoryIcon(String category) {
  switch (category.toLowerCase()) {
    case "low":
      return Icons.trending_down;
    case "medium":
      return Icons.trending_flat;
    case "high":
      return Icons.trending_up;
    default:
      return Icons.help_outline;
  }
}

/// Shows the prediction result: Yield Category in its matching color
/// (Low = red, Medium = dark yellow, High = green) plus the expected yield value.
class ResultCard extends StatelessWidget {
  final PredictionResult result;
  const ResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final color = categoryColor(result.yieldCategory);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(categoryIcon(result.yieldCategory), color: color, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Yield Category: ${result.yieldCategory}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text("Expected Yield", style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
          Text(
            result.expectedYield.toStringAsFixed(2),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.darkGreen),
          ),
          const SizedBox(height: 8),
          Text(
            "For ${result.request.crop} in ${result.request.state} (${result.request.season})",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
