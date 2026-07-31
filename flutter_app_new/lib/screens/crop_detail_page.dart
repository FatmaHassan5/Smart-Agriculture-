import 'package:flutter/material.dart';
import '../data/crop_info_data.dart';
import '../theme/app_theme.dart';

class CropDetailPage extends StatelessWidget {
  final CropInfo crop;
  const CropDetailPage({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primaryGreen,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(crop.name, style: const TextStyle(color: Colors.white, fontSize: 16)),
              background: Image.network(
                crop.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: AppColors.lightGreen),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(crop.description, style: const TextStyle(fontSize: 15, height: 1.5)),
                  const SizedBox(height: 20),
                  _infoRow(Icons.calendar_month, "Ideal Season", crop.idealSeason),
                  _infoRow(Icons.science, "NPK Guidance", crop.npkTip),
                  _infoRow(Icons.opacity, "Soil pH Range", crop.phRange),
                  const SizedBox(height: 12),
                  const Text(
                    "Growing Tips",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.darkGreen),
                  ),
                  const SizedBox(height: 8),
                  ...crop.growingTips.map(
                    (tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle, size: 18, color: AppColors.highColor),
                          const SizedBox(width: 8),
                          Expanded(child: Text(tip)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.earthBrown, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
