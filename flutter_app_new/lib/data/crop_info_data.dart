class CropInfo {
  final String name;
  final String imageUrl;
  final String description;
  final String idealSeason;
  final String npkTip;
  final String phRange;
  final List<String> growingTips;

  const CropInfo({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.idealSeason,
    required this.npkTip,
    required this.phRange,
    required this.growingTips,
  });
}

/// A starter knowledge base for the crops most common in the training data.
/// Replace `imageUrl` with your own bundled assets any time — network images
/// are used here only as placeholders so the app looks complete out of the box.
final List<CropInfo> cropInfoDatabase = [
  const CropInfo(
    name: "Rice",
    imageUrl: "https://images.unsplash.com/photo-1536304993881-ff6e9eefa2a6?w=600",
    description:
        "A staple cereal grown mostly in flooded paddies across warm, humid regions. One of the most widely cultivated crops in the world.",
    idealSeason: "Kharif / Rabi",
    npkTip: "Responds well to balanced Nitrogen with moderate Phosphorus and Potassium.",
    phRange: "5.5 - 6.5",
    growingTips: [
      "Needs standing water for most of the growing cycle.",
      "Warm temperatures (20-35°C) support strong growth.",
      "Consistent rainfall or irrigation greatly improves yield.",
    ],
  ),
  const CropInfo(
    name: "Cotton(lint)",
    imageUrl: "https://images.unsplash.com/photo-1605000797499-95a51c5269ae?w=600",
    description:
        "A fiber crop that needs a long, warm growing season and moderate rainfall, harvested for lint used in textiles.",
    idealSeason: "Kharif",
    npkTip: "Higher Potassium needs during the boll-forming stage.",
    phRange: "5.8 - 8.0",
    growingTips: [
      "Sensitive to waterlogging — needs well-drained soil.",
      "Warm days (25-35°C) speed up boll development.",
      "Moderate, evenly spread rainfall is better than heavy bursts.",
    ],
  ),
  const CropInfo(
    name: "Maize",
    imageUrl: "https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=600",
    description:
        "A versatile cereal grown in both Kharif and Rabi seasons, used for food, feed, and industrial products.",
    idealSeason: "Kharif / Rabi",
    npkTip: "High Nitrogen demand, especially during the vegetative stage.",
    phRange: "5.5 - 7.5",
    growingTips: [
      "Grows best with warm days and cool nights.",
      "Needs consistent moisture during silking and grain-filling.",
      "Responds strongly to well-timed Nitrogen application.",
    ],
  ),
  const CropInfo(
    name: "Groundnut",
    imageUrl: "https://images.unsplash.com/photo-1567892737950-30c4db37cd89?w=600",
    description:
        "A legume oilseed crop that also improves soil nitrogen through natural fixation.",
    idealSeason: "Kharif / Rabi",
    npkTip: "Lower Nitrogen needs (it fixes its own), but benefits from Phosphorus and Calcium.",
    phRange: "6.0 - 6.5",
    growingTips: [
      "Prefers light, well-drained sandy loam soils.",
      "Sensitive to waterlogging during pod development.",
      "Calcium availability is important for healthy pod filling.",
    ],
  ),
  const CropInfo(
    name: "Jowar",
    imageUrl: "https://images.unsplash.com/photo-1622383563227-04401ab4e5ea?w=600",
    description:
        "A drought-tolerant cereal (sorghum) widely grown in semi-arid regions as food and fodder.",
    idealSeason: "Kharif / Rabi",
    npkTip: "Moderate Nitrogen needs; performs reasonably even with limited fertilizer.",
    phRange: "6.0 - 7.5",
    growingTips: [
      "One of the most drought-tolerant cereal crops.",
      "Performs well in low-to-moderate rainfall areas.",
      "Avoid waterlogged soils.",
    ],
  ),
  const CropInfo(
    name: "Bajra",
    imageUrl: "https://images.unsplash.com/photo-1595855759920-86582396756a?w=600",
    description:
        "Pearl millet — a hardy, fast-growing cereal suited to hot, dry climates and poor soils.",
    idealSeason: "Kharif",
    npkTip: "Low to moderate fertilizer requirement; efficient nutrient use.",
    phRange: "6.2 - 7.5",
    growingTips: [
      "Extremely tolerant of heat and low rainfall.",
      "Grows well even in sandy, less fertile soils.",
      "Good rotation crop after legumes.",
    ],
  ),
  const CropInfo(
    name: "Gram",
    imageUrl: "https://images.unsplash.com/photo-1610348725531-843dff563e2c?w=600",
    description:
        "Chickpea — a cool-season legume grown mainly in the Rabi season, valued for protein content.",
    idealSeason: "Rabi",
    npkTip: "Fixes its own Nitrogen; benefits more from Phosphorus.",
    phRange: "6.0 - 7.5",
    growingTips: [
      "Prefers cool, dry weather during growth.",
      "Avoid excess irrigation — sensitive to waterlogging.",
      "Light, well-drained loam soils give best results.",
    ],
  ),
  const CropInfo(
    name: "Sesamum",
    imageUrl: "https://images.unsplash.com/photo-1622383563227-04401ab4e5ea?w=600",
    description:
        "Sesame — an oilseed crop that tolerates heat and drought well, grown for its edible oil-rich seeds.",
    idealSeason: "Kharif / Rabi",
    npkTip: "Light feeder; moderate Nitrogen and Phosphorus are usually sufficient.",
    phRange: "5.5 - 8.0",
    growingTips: [
      "Very sensitive to waterlogging — needs good drainage.",
      "Tolerates heat and short dry spells well.",
      "Best sown in warm soil for even germination.",
    ],
  ),
  const CropInfo(
    name: "Mesta",
    imageUrl: "https://images.unsplash.com/photo-1500937386664-56d1dfef3854?w=600",
    description:
        "A fiber crop related to jute, grown mainly in warm, humid regions for its strong bast fiber.",
    idealSeason: "Kharif",
    npkTip: "Moderate to high Nitrogen supports strong fiber growth.",
    phRange: "5.5 - 7.5",
    growingTips: [
      "Needs warm temperatures and consistent moisture.",
      "Grows tall quickly — dense sowing is common.",
      "Harvest timing affects fiber quality significantly.",
    ],
  ),
  const CropInfo(
    name: "Dry chillies",
    imageUrl: "https://images.unsplash.com/photo-1583119022894-919a68a3d0e3?w=600",
    description:
        "A high-value spice crop grown for its pungent pods, sun-dried after harvest.",
    idealSeason: "Kharif / Rabi",
    npkTip: "Benefits from balanced NPK with extra Potassium during fruiting.",
    phRange: "6.0 - 7.0",
    growingTips: [
      "Needs warm weather and moderate, well-distributed rainfall.",
      "Avoid waterlogging — raised beds often help.",
      "Regular but not excessive irrigation improves pod quality.",
    ],
  ),
];

/// Returns a CropInfo for the given name, or a sensible generic placeholder
/// if the crop isn't yet in the local knowledge base.
CropInfo getCropInfo(String cropName) {
  return cropInfoDatabase.firstWhere(
    (c) => c.name.toLowerCase() == cropName.toLowerCase(),
    orElse: () => CropInfo(
      name: cropName,
      imageUrl: "https://images.unsplash.com/photo-1500937386664-56d1dfef3854?w=600",
      description: "Detailed growing information for $cropName is being added soon.",
      idealSeason: "Varies by region",
      npkTip: "Follow local agricultural extension recommendations for NPK dosage.",
      phRange: "6.0 - 7.5 (general range)",
      growingTips: const [
        "Consult local soil test results for precise fertilizer needs.",
        "Monitor rainfall and irrigation closely during the growing season.",
      ],
    ),
  );
}


// State:
// Andhra Pradesh

// Crop:
// Rice

// Season:
// Kharif

// N:
// 80

// P:
// 40

// K:
// 40

// pH:
// 6.5

// Temperature:
// 28

// Rainfall:
// 120

// Humidity:
// 75

// Fertilizer:
// 100

// Pesticide:
// 20