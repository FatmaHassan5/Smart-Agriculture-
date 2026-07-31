import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prediction_model.dart';

class ApiService {
  /// TODO: replace with your deployed FastAPI base URL.
  /// - Android emulator -> host machine localhost: "http://10.0.2.2:8000"
  /// - iOS simulator    -> "http://127.0.0.1:8000"
  /// - Physical device / production -> your real server URL, e.g. "https://your-api.com"
  static const String baseUrl = "http://10.0.2.2:8000";

  static Future<AppOptions> fetchOptions() async {
    final response = await http.get(Uri.parse("$baseUrl/options"));
    if (response.statusCode != 200) {
      throw Exception("Failed to load options (${response.statusCode})");
    }
    return AppOptions.fromJson(jsonDecode(response.body));
  }

  static Future<PredictionResult> predict(PredictionRequest request) async {
    final response = await http.post(
      Uri.parse("$baseUrl/predict"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      try {
        final body = jsonDecode(response.body);
        throw Exception(body["detail"]?.toString() ?? "Prediction failed");
      } catch (_) {
        throw Exception("Prediction failed (${response.statusCode})");
      }
    }

    return PredictionResult.fromJson(jsonDecode(response.body), request);
  }
}
