import 'package:flutter/material.dart';
import '../models/prediction_model.dart';
import '../services/api_service.dart';

class PredictionProvider extends ChangeNotifier {
  PredictionResult? lastResult;
  bool isLoading = false;
  String? errorMessage;

  Future<void> runPrediction(PredictionRequest request) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      lastResult = await ApiService.predict(request);
    } catch (e) {
      errorMessage = e.toString().replaceFirst("Exception: ", "");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
