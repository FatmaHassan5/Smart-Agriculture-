import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/prediction_model.dart';
import '../services/api_service.dart';
import '../state/prediction_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/result_card.dart';
import '../widgets/section_title.dart';

class PredictScreen extends StatefulWidget {
  const PredictScreen({super.key});

  @override
  State<PredictScreen> createState() => _PredictScreenState();
}

class _PredictScreenState extends State<PredictScreen> {
  final _formKey = GlobalKey<FormState>();

  AppOptions? _options;
  bool _loadingOptions = true;
  String? _optionsError;

  String? _state;
  String? _crop;
  String? _season;

  final _nCtrl = TextEditingController();
  final _pCtrl = TextEditingController();
  final _kCtrl = TextEditingController();
  final _phCtrl = TextEditingController();
  final _tempCtrl = TextEditingController();
  final _rainCtrl = TextEditingController();
  final _humidityCtrl = TextEditingController();
  final _fertCtrl = TextEditingController();
  final _pestCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    try {
      final options = await ApiService.fetchOptions();
      setState(() {
        _options = options;
        _loadingOptions = false;
      });
    } catch (e) {
      setState(() {
        _optionsError = e.toString().replaceFirst("Exception: ", "");
        _loadingOptions = false;
      });
    }
  }

  @override
  void dispose() {
    for (final c in [
      _nCtrl,
      _pCtrl,
      _kCtrl,
      _phCtrl,
      _tempCtrl,
      _rainCtrl,
      _humidityCtrl,
      _fertCtrl,
      _pestCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  double _num(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_state == null || _crop == null || _season == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select state, crop, and season")),
      );
      return;
    }

    final request = PredictionRequest(
      state: _state!,
      crop: _crop!,
      season: _season!,
      n: _num(_nCtrl),
      p: _num(_pCtrl),
      k: _num(_kCtrl),
      ph: _num(_phCtrl),
      temperature: _num(_tempCtrl),
      rainfall: _num(_rainCtrl),
      humidity: _num(_humidityCtrl),
      fertilizerPerArea: _num(_fertCtrl),
      pesticidePerArea: _num(_pestCtrl),
    );

    await context.read<PredictionProvider>().runPrediction(request);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PredictionProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Yield Prediction")),
      body: _loadingOptions
          ? const Center(child: CircularProgressIndicator())
          : _optionsError != null
              ? _ErrorRetry(
                  message: _optionsError!,
                  onRetry: () {
                    setState(() => _loadingOptions = true);
                    _loadOptions();
                  },
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _HeaderBanner(),
                        const SizedBox(height: 20),
                        const SectionTitle(icon: Icons.map_outlined, text: "Location & Crop"),
                        const SizedBox(height: 10),
                        _dropdown("State", _options!.states, _state, (v) => setState(() => _state = v)),
                        const SizedBox(height: 12),
                        _dropdown("Crop", _options!.crops, _crop, (v) => setState(() => _crop = v)),
                        const SizedBox(height: 12),
                        _dropdown("Season", _options!.seasons, _season, (v) => setState(() => _season = v)),
                        const SizedBox(height: 20),
                        const SectionTitle(icon: Icons.science_outlined, text: "Soil Nutrients"),
                        const SizedBox(height: 10),
                        Row(children: [
                          Expanded(child: _numberField("Nitrogen (N)", _nCtrl)),
                          const SizedBox(width: 10),
                          Expanded(child: _numberField("Phosphorus (P)", _pCtrl)),
                        ]),
                        const SizedBox(height: 12),
                        Row(children: [
                          Expanded(child: _numberField("Potassium (K)", _kCtrl)),
                          const SizedBox(width: 10),
                          Expanded(child: _numberField("Soil pH", _phCtrl, max: 14)),
                        ]),
                        const SizedBox(height: 20),
                        const SectionTitle(icon: Icons.wb_sunny_outlined, text: "Climate"),
                        const SizedBox(height: 10),
                        _numberField("Temperature (°C)", _tempCtrl),
                        const SizedBox(height: 12),
                        _numberField("Rainfall (mm)", _rainCtrl),
                        const SizedBox(height: 12),
                        _numberField("Humidity (%)", _humidityCtrl),
                        const SizedBox(height: 20),
                        const SectionTitle(icon: Icons.spa_outlined, text: "Inputs"),
                        const SizedBox(height: 10),
                        _numberField("Fertilizer (kg/hectare)", _fertCtrl),
                        const SizedBox(height: 12),
                        _numberField("Pesticide (kg/hectare)", _pestCtrl),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: provider.isLoading ? null : _submit,
                            icon: provider.isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Icon(Icons.auto_awesome),
                            label: Text(provider.isLoading ? "Predicting..." : "Predict Yield"),
                          ),
                        ),
                        if (provider.errorMessage != null) ...[
                          const SizedBox(height: 14),
                          Text(provider.errorMessage!, style: const TextStyle(color: AppColors.lowColor)),
                        ],
                        if (provider.lastResult != null) ...[
                          const SizedBox(height: 24),
                          ResultCard(result: provider.lastResult!),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Icon(Icons.lightbulb_outline, size: 16, color: AppColors.earthBrown),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "Open the Insights tab for personalized recommendations",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12, color: AppColors.earthBrown),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _dropdown(
    String label,
    List<String> items,
    String? value,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? "Required" : null,
      isExpanded: true,
    );
  }

  Widget _numberField(String label, TextEditingController controller, {double? max}) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return "Required";
        final parsed = double.tryParse(v.trim());
        if (parsed == null || parsed < 0) return "Enter a valid number";
        if (max != null && parsed > max) return "Max $max";
        return null;
      },
    );
  }
}

class _HeaderBanner extends StatelessWidget {
  const _HeaderBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primaryGreen, AppColors.lightGreen]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.agriculture, color: Colors.white, size: 36),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              "Enter your field conditions to get an instant yield prediction",
              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorRetry({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
          ],
        ),
      ),
    );
  }
}