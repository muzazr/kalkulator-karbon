import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'calculator_shared_widgets.dart';

class FuelIndustry extends StatelessWidget {
  const FuelIndustry({super.key});

  @override
  Widget build(BuildContext context) {
    final FuelIndustryCalculatorController controller =
        Get.put(FuelIndustryCalculatorController());

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
                    Obx(
                      () => CalculatorDropdownField(
                        label: 'Jenis bahan bakar',
                        hint: 'Pilih jenis bahan bakar',
                        value: controller.selectedFuelType.value,
                        items: controller.fuelTypes,
                        onChanged: controller.onFuelTypeChanged,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => CalculatorTextField(
                        label: 'Konsumsi bahan bakar per hari',
                        hint: 'Masukkan konsumsi per hari',
                        suffix: controller.selectedFuelUnit,
                        controller: controller.konsumsiPerHariController,
                        allowDecimal: true,
                        maxLength: 12,
                      ),
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
                  onPressed: controller.hitungJejakKarbon,
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

class FuelIndustryCalculatorController extends GetxController {
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

  final RxnString selectedFuelType = RxnString();
  final RxDouble hasilCO2Harian = 0.0.obs;
  final RxDouble hasilCO2Mingguan = 0.0.obs;
  final RxDouble hasilCO2Bulanan = 0.0.obs;
  final RxString selectedTab = 'Hari'.obs;
  final RxBool showResult = false.obs;

  List<String> get fuelTypes => _faktorEmisiBahanBakar.keys.toList();

  String get selectedFuelUnit {
    final String? fuelType = selectedFuelType.value;
    if (fuelType == null) {
      return 'liter';
    }

    return _satuanBahanBakar[fuelType] ?? 'liter';
  }

  void onFuelTypeChanged(String? value) {
    selectedFuelType.value = value;
  }

  double? _parseNumber(String value) {
    return double.tryParse(value.trim().replaceAll(',', '.'));
  }

  void _showError(String message) {
    Get.snackbar(
      'ERROR!',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.black,
    );
  }

  void hitungJejakKarbon() {
    final String? fuelType = selectedFuelType.value;
    final String konsumsiText = konsumsiPerHariController.text.trim();
    final String jumlahUnitText = jumlahUnitController.text.trim();
    final String hariOperasiText = hariOperasiController.text.trim();

    if (fuelType == null ||
        konsumsiText.isEmpty ||
        jumlahUnitText.isEmpty ||
        hariOperasiText.isEmpty) {
      _showError('Semua field harus diisi!');
      return;
    }

    final double? konsumsiPerHari = _parseNumber(konsumsiText);
    final int? jumlahUnit = int.tryParse(jumlahUnitText);
    final int? hariOperasi = int.tryParse(hariOperasiText);

    if (konsumsiPerHari == null || jumlahUnit == null || hariOperasi == null) {
      _showError('Angka yang dimasukkan tidak valid.');
      return;
    }

    if (konsumsiPerHari <= 0) {
      _showError('Konsumsi per hari harus lebih dari 0.');
      return;
    }

    if (jumlahUnit < 1) {
      _showError('Jumlah unit minimal 1.');
      return;
    }

    if (hariOperasi < 1 || hariOperasi > 31) {
      _showError('Hari operasi per bulan harus antara 1 sampai 31.');
      return;
    }

    final double faktorEmisi = _faktorEmisiBahanBakar[fuelType] ?? 0;
    final double konsumsiBulanan = konsumsiPerHari * jumlahUnit * hariOperasi;
    final double emisiBulanan = konsumsiBulanan * faktorEmisi;
    final double emisiHarian = emisiBulanan / hariOperasi;
    final double emisiMingguan = emisiHarian * 7;

    hasilCO2Harian.value = emisiHarian;
    hasilCO2Mingguan.value = emisiMingguan;
    hasilCO2Bulanan.value = emisiBulanan;
    selectedTab.value = 'Hari';
    showResult.value = true;
  }

  @override
  void onClose() {
    konsumsiPerHariController.dispose();
    jumlahUnitController.dispose();
    hariOperasiController.dispose();
    super.onClose();
  }
}
