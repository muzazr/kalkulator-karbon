import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'calculator_shared_widgets.dart';

final AutoDisposeChangeNotifierProvider<FuelIndustryCalculatorController>
    fuelIndustryControllerProvider =
    ChangeNotifierProvider.autoDispose<FuelIndustryCalculatorController>(
  (ref) => FuelIndustryCalculatorController(),
);

class FuelIndustry extends ConsumerWidget {
  const FuelIndustry({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FuelIndustryCalculatorController controller =
        ref.watch(fuelIndustryControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FeatureCalculatorHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    const Center(
                      child: Text(
                        'Bahan Bakar Industri',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    CalculatorDropdownField(
                      label: 'Jenis bahan bakar',
                      hint: 'Pilih jenis bahan bakar',
                      value: controller.selectedFuelType,
                      items: controller.fuelTypes,
                      onChanged: controller.onFuelTypeChanged,
                    ),
                    const SizedBox(height: 20),
                    CalculatorTextField(
                      label: 'Konsumsi bahan bakar per hari',
                      hint: 'Masukkan konsumsi per hari',
                      suffix: controller.selectedFuelUnit,
                      controller: controller.konsumsiPerHariController,
                      allowDecimal: true,
                      maxLength: 12,
                    ),
                    const SizedBox(height: 20),
                    CalculatorTextField(
                      label: 'Jumlah unit mesin/peralatan',
                      hint: 'Masukkan jumlah unit',
                      suffix: 'unit',
                      controller: controller.jumlahUnitController,
                      maxLength: 6,
                    ),
                    const SizedBox(height: 20),
                    CalculatorTextField(
                      label: 'Hari operasi dalam sebulan',
                      hint: 'Masukkan hari operasi',
                      suffix: 'hari',
                      controller: controller.hariOperasiController,
                      maxLength: 2,
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Kalkulasi emisi mengikuti jenis bahan bakar dan total konsumsi bulanan.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CarbonResultCard(
                      showResult: controller.showResult,
                      selectedTab: controller.selectedTab,
                      harian: controller.hasilCO2Harian,
                      mingguan: controller.hasilCO2Mingguan,
                      bulanan: controller.hasilCO2Bulanan,
                      onTabChanged: controller.updateTab,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.hitungJejakKarbon(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF018D58),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Hitung',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FuelIndustryCalculatorController extends ChangeNotifier {
  static const Map<String, double> _faktorEmisiBahanBakar = {
    'bensin': 2.24,
    'solar': 2.69,
    'lpg': 3.00,
    'minyak tanah': 2.61,
    'gas alam': 1.90,
  };

  static const Map<String, String> _satuanBahanBakar = {
    'bensin': 'liter',
    'solar': 'liter',
    'lpg': 'kg',
    'minyak tanah': 'liter',
    'gas alam': 'm3',
  };

  final TextEditingController konsumsiPerHariController =
      TextEditingController();
  final TextEditingController jumlahUnitController = TextEditingController();
  final TextEditingController hariOperasiController = TextEditingController();

  String? selectedFuelType;
  double hasilCO2Harian = 0.0;
  double hasilCO2Mingguan = 0.0;
  double hasilCO2Bulanan = 0.0;
  String selectedTab = 'Hari';
  bool showResult = false;

  List<String> get fuelTypes => _faktorEmisiBahanBakar.keys.toList();

  String get selectedFuelUnit {
    final String? fuelType = selectedFuelType;
    if (fuelType == null) {
      return 'liter';
    }
    return _satuanBahanBakar[fuelType] ?? 'liter';
  }

  void onFuelTypeChanged(String? value) {
    selectedFuelType = value;
    notifyListeners();
  }

  void updateTab(String tab) {
    selectedTab = tab;
    notifyListeners();
  }

  double? _parseNumber(String value) {
    return double.tryParse(value.trim().replaceAll(',', '.'));
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade600),
    );
  }

  void hitungJejakKarbon(BuildContext context) {
    final String? fuelType = selectedFuelType;
    final String konsumsiText = konsumsiPerHariController.text.trim();
    final String jumlahUnitText = jumlahUnitController.text.trim();
    final String hariOperasiText = hariOperasiController.text.trim();

    if (fuelType == null ||
        konsumsiText.isEmpty ||
        jumlahUnitText.isEmpty ||
        hariOperasiText.isEmpty) {
      _showError(context, 'Semua field harus diisi!');
      return;
    }

    final double? konsumsiPerHari = _parseNumber(konsumsiText);
    final int? jumlahUnit = int.tryParse(jumlahUnitText);
    final int? hariOperasi = int.tryParse(hariOperasiText);

    if (konsumsiPerHari == null || jumlahUnit == null || hariOperasi == null) {
      _showError(context, 'Angka yang dimasukkan tidak valid.');
      return;
    }

    if (konsumsiPerHari <= 0) {
      _showError(context, 'Konsumsi per hari harus lebih dari 0.');
      return;
    }

    if (jumlahUnit < 1) {
      _showError(context, 'Jumlah unit minimal 1.');
      return;
    }

    if (hariOperasi < 1 || hariOperasi > 31) {
      _showError(context, 'Hari operasi per bulan harus antara 1 sampai 31.');
      return;
    }

    final double faktorEmisi = _faktorEmisiBahanBakar[fuelType] ?? 0;
    final double konsumsiBulanan = konsumsiPerHari * jumlahUnit * hariOperasi;
    final double emisiBulanan = konsumsiBulanan * faktorEmisi;
    final double emisiHarian = emisiBulanan / hariOperasi;
    final double emisiMingguan = emisiHarian * 7;

    hasilCO2Harian = emisiHarian;
    hasilCO2Mingguan = emisiMingguan;
    hasilCO2Bulanan = emisiBulanan;
    selectedTab = 'Hari';
    showResult = true;
    notifyListeners();
  }

  @override
  void dispose() {
    konsumsiPerHariController.dispose();
    jumlahUnitController.dispose();
    hariOperasiController.dispose();
    super.dispose();
  }
}
