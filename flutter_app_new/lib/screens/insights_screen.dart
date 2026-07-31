import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/crop_info_data.dart';
import '../models/prediction_model.dart';
import '../state/prediction_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/result_card.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PredictionProvider>();
    final result = provider.lastResult;

    return Scaffold(
      appBar: AppBar(title: const Text("Insights & Recommendations")),
      body: result == null
          ? const _EmptyState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResultCard(result: result),
                  const SizedBox(height: 20),
                  _CategoryExplanationCard(category: result.yieldCategory),
                  const SizedBox(height: 20),
                  _CropTipsCard(cropName: result.request.crop),
                  const SizedBox(height: 20),
                  _ActionTipsCard(result: result),
                  const SizedBox(height: 12),
                ],
              ),
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.insights_outlined, size: 56, color: Colors.grey),
            const SizedBox(height: 14),
            const Text(
              "Run a prediction first to see personalized insights and recommendations here.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryExplanationCard extends StatelessWidget {
  final String category;
  const _CategoryExplanationCard({required this.category});

  String get _explanation {
    switch (category.toLowerCase()) {
      case "low":
        return "Your predicted yield falls in the lower range compared to historical data for similar conditions. Review the soil nutrients and input levels below for ideas.";
      case "medium":
        return "Your predicted yield is around the typical average for these conditions. Small adjustments to inputs could push it higher.";
      case "high":
        return "Your predicted yield is in the top range for these conditions — your inputs are well matched to this crop.";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      icon: Icons.info_outline,
      title: "What does '$category' mean?",
      child: Text(_explanation, style: const TextStyle(height: 1.5)),
    );
  }
}

class _CropTipsCard extends StatelessWidget {
  final String cropName;
  const _CropTipsCard({required this.cropName});

  @override
  Widget build(BuildContext context) {
    final info = getCropInfo(cropName);
    return _InfoCard(
      icon: Icons.eco,
      title: "Growing Tips for $cropName",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: info.growingTips
            .map(
              (t) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("• "),
                    Expanded(child: Text(t)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ActionTipsCard extends StatelessWidget {
  final PredictionResult result;
  const _ActionTipsCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final req = result.request;
    final tips = <String>[];

    if (result.yieldCategory.toLowerCase() != "high") {
      if (req.fertilizerPerArea < 50) {
        tips.add(
          "Fertilizer usage (${req.fertilizerPerArea.toStringAsFixed(1)} kg/ha) looks on the lower side — "
          "consider a soil test to check if a moderate increase would help.",
        );
      }
      if (req.ph < 5.5 || req.ph > 7.5) {
        tips.add(
          "Soil pH (${req.ph.toStringAsFixed(1)}) is outside the commonly ideal 5.5–7.5 range for most crops — "
          "pH correction may improve nutrient uptake.",
        );
      }
      if (req.rainfall < 500) {
        tips.add(
          "Rainfall (${req.rainfall.toStringAsFixed(0)} mm) is relatively low — "
          "supplemental irrigation may help stabilize yield.",
        );
      }
    }
    if (tips.isEmpty) {
      tips.add("Your current inputs look well balanced for this crop and season.");
    }

    return _InfoCard(
      icon: Icons.tips_and_updates_outlined,
      title: "Suggested Actions",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tips
            .map(
              (t) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_right, color: AppColors.primaryGreen),
                    Expanded(child: Text(t)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  const _InfoCard({required this.icon, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryGreen),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15))),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
