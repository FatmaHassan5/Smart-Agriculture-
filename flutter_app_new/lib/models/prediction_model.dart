class PredictionRequest {
  final String state;
  final String crop;
  final String season;
  final double n;
  final double p;
  final double k;
  final double ph;
  final double temperature;
  final double rainfall;
  final double humidity;
  final double fertilizerPerArea;
  final double pesticidePerArea;

  PredictionRequest({
    required this.state,
    required this.crop,
    required this.season,
    required this.n,
    required this.p,
    required this.k,
    required this.ph,
    required this.temperature,
    required this.rainfall,
    required this.humidity,
    required this.fertilizerPerArea,
    required this.pesticidePerArea,
  });

  /// Matches the FastAPI `PredictionRequest` pydantic model exactly.
  Map<String, dynamic> toJson() => {
        "state": state,
        "crop": crop,
        "season": season,
        "n": n,
        "p": p,
        "k": k,
        "ph": ph,
        "temperature": temperature,
        "rainfall": rainfall,
        "humidity": humidity,
        "fertilizer_per_area": fertilizerPerArea,
        "pesticide_per_area": pesticidePerArea,
      };
}

class PredictionResult {
  final String yieldCategory;
  final double expectedYield;

  /// Keep the inputs that produced this result — used by the Insights screen
  /// to generate personalized recommendations.
  final PredictionRequest request;

  PredictionResult({
    required this.yieldCategory,
    required this.expectedYield,
    required this.request,
  });

  factory PredictionResult.fromJson(
    Map<String, dynamic> json,
    PredictionRequest request,
  ) {
    return PredictionResult(
      yieldCategory: json["yield_category"] as String,
      expectedYield: (json["expected_yield"] as num).toDouble(),
      request: request,
    );
  }
}

class AppOptions {
  final List<String> states;
  final List<String> crops;
  final List<String> seasons;

  AppOptions({required this.states, required this.crops, required this.seasons});

  factory AppOptions.fromJson(Map<String, dynamic> json) {
    return AppOptions(
      states: List<String>.from(json["states"] ?? []),
      crops: List<String>.from(json["crops"] ?? []),
      seasons: List<String>.from(json["seasons"] ?? []),
    );
  }
}
