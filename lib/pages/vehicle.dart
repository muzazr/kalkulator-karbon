import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'calculator_shared_widgets.dart';

class Vehicle extends StatelessWidget {
  const Vehicle({super.key});

  @override
  Widget build(BuildContext context) {
    final VehicleCalculatorController controller =
        Get.put(VehicleCalculatorController());

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
                        'Kendaraan',
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
                        label: 'Jenis kendaraan',
                        hint: 'Pilih jenis kendaraan',
                        value: controller.selectedVehicleType.value,
                        items: controller.vehicleTypes,
                        onChanged: controller.onVehicleTypeChanged,
                      ),
                    ),
                    const SizedBox(height: 20),
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
                    CalculatorTextField(
                      label: 'Jarak tempuh rata-rata per hari',
                      hint: 'Masukkan jarak tempuh per hari',
                      suffix: 'km',
                      controller: controller.jarakPerHariController,
                      allowDecimal: true,
                      maxLength: 12,
                    ),
                    const SizedBox(height: 20),
                    CalculatorTextField(
                      label: 'Efisiensi kendaraan (km/liter)',
                      hint: 'Masukkan efisiensi kendaraan',
                      suffix: 'km/liter',
                      controller: controller.efisiensiController,
                      allowDecimal: true,
                      maxLength: 12,
                    ),
                    const SizedBox(height: 20),
                    CalculatorTextField(
                      label: 'Hari penggunaan dalam sebulan',
                      hint: 'Masukkan jumlah hari',
                      suffix: 'hari',
                      controller: controller.hariPerBulanController,
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
                        'Perhitungan didasarkan pada jarak tempuh, efisiensi kendaraan, dan faktor emisi bahan bakar.',
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
            ),
          ],
        ),
      ),
    );
  }
}

class VehicleCalculatorController extends GetxController {
  static const Map<String, double> _faktorEmisiBahanBakar = {
    'bensin': 2.24,
    'solar': 2.69,
  };

  final TextEditingController jarakPerHariController = TextEditingController();
  final TextEditingController efisiensiController = TextEditingController();
  final TextEditingController hariPerBulanController = TextEditingController();

  final RxnString selectedVehicleType = RxnString();
  final RxnString selectedFuelType = RxnString();

  final RxDouble hasilCO2Harian = 0.0.obs;
  final RxDouble hasilCO2Mingguan = 0.0.obs;
  final RxDouble hasilCO2Bulanan = 0.0.obs;
  final RxString selectedTab = 'Hari'.obs;
  final RxBool showResult = false.obs;

  List<String> get vehicleTypes => const [
        'motor',
        'mobil',
        'van/pickup',
        'truk',
      ];

  List<String> get fuelTypes => _faktorEmisiBahanBakar.keys.toList();

  void onVehicleTypeChanged(String? value) {
    selectedVehicleType.value = value;
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
    final String? vehicleType = selectedVehicleType.value;
    final String? fuelType = selectedFuelType.value;
    final String jarakText = jarakPerHariController.text.trim();
    final String efisiensiText = efisiensiController.text.trim();
    final String hariPerBulanText = hariPerBulanController.text.trim();

    if (vehicleType == null ||
        fuelType == null ||
        jarakText.isEmpty ||
        efisiensiText.isEmpty ||
        hariPerBulanText.isEmpty) {
      _showError('Semua field harus diisi!');
      return;
    }

    final double? jarakPerHari = _parseNumber(jarakText);
    final double? efisiensiKmPerLiter = _parseNumber(efisiensiText);
    final int? hariPerBulan = int.tryParse(hariPerBulanText);

    if (jarakPerHari == null ||
        efisiensiKmPerLiter == null ||
        hariPerBulan == null) {
      _showError('Angka yang dimasukkan tidak valid.');
      return;
    }

    if (jarakPerHari <= 0) {
      _showError('Jarak tempuh per hari harus lebih dari 0.');
      return;
    }

    if (efisiensiKmPerLiter <= 0) {
      _showError('Efisiensi kendaraan harus lebih dari 0.');
      return;
    }

    if (hariPerBulan < 1 || hariPerBulan > 31) {
      _showError('Hari penggunaan per bulan harus antara 1 sampai 31.');
      return;
    }

    final double faktorEmisi = _faktorEmisiBahanBakar[fuelType] ?? 0;
    final double literPerBulan =
        (jarakPerHari * hariPerBulan) / efisiensiKmPerLiter;
    final double emisiBulanan = literPerBulan * faktorEmisi;
    final double emisiHarian = emisiBulanan / hariPerBulan;
    final double emisiMingguan = emisiHarian * 7;

    hasilCO2Harian.value = emisiHarian;
    hasilCO2Mingguan.value = emisiMingguan;
    hasilCO2Bulanan.value = emisiBulanan;
    selectedTab.value = 'Hari';
    showResult.value = true;
  }

  @override
  void onClose() {
    jarakPerHariController.dispose();
    efisiensiController.dispose();
    hariPerBulanController.dispose();
    super.onClose();
  }
}
