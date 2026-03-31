import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'select_feature.dart';

class ElectricArea extends StatelessWidget {
  const ElectricArea({super.key});

  @override
  Widget build(BuildContext context) {
    final ElectricAreaCalculatorController controller =
        Get.put(ElectricAreaCalculatorController());

    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _HeaderFeaturePage(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  const Center(
                    child: Text(
                      'Konsumsi Listrik Wilayah',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 22),
                    ),
                  ),
                  const SizedBox(height: 25),
                  RichText(
                    text: const TextSpan(
                      text: 'Kapasitas Beban (PK)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const _KapasitasBebanDropdown(),
                  const SizedBox(height: 20),
                  _CustomTextField(
                      label: 'Jumlah Total Area',
                      hint: 'Masukkan jumlah total area',
                      suffix: 'area',
                      maxValue: 1000,
                      minValue: 1,
                      maxLength: 6,
                      errorMessageEmpty: 'Wajib masukkan jumlah area!',
                      controller: controller.jumlahAreaController),
                  const SizedBox(height: 20),
                  _CustomTextField(
                      label: 'Durasi',
                      hint: 'Masukkan durasi penggunaan',
                      suffix: 'Jam/Hari',
                      maxValue: 24,
                      minValue: 1,
                      maxLength: 3,
                      errorMessageEmpty: 'Wajib masukkan durasi penggunaan!',
                      controller: controller.durasiController),
                  const SizedBox(height: 20),
                  _CustomTextField(
                      label: 'Total Hari Digunakan dalam Sebulan',
                      hint: 'Total Penggunaan dalam Sebulan',
                      suffix: 'Hari',
                      maxValue: 30,
                      minValue: 1,
                      maxLength: 3,
                      errorMessageEmpty: 'Wajib masukkan hari penggunaan!',
                      controller: controller.hariController),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      'Kalkulasi yang digunakan sudah sesuai dengan jurnal dan literatur resmi.',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _ResultCard(controller: controller),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 4,
                  offset: const Offset(0, -2))
            ]),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.hitungJejakKarbon(),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF018D58),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: const Text(
                  'Hitung',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}

class ElectricAreaCalculatorController extends GetxController {
  final jumlahAreaController = TextEditingController();
  final durasiController = TextEditingController();
  final hariController = TextEditingController();

  var selectedKapasitas = Rxn<double>();
  var hasilCO2Harian = 0.0.obs;
  var hasilCO2Mingguan = 0.0.obs;
  var hasilCO2Bulanan = 0.0.obs;
  var selectedTab = 'Hari'.obs;
  var showResult = false.obs;

  @override
  void onClose() {
    jumlahAreaController.dispose();
    durasiController.dispose();
    hariController.dispose();
    super.onClose();
  }

  void hitungJejakKarbon() {
    final int? jumlahArea = int.tryParse(jumlahAreaController.text);
    final int? durasi = int.tryParse(durasiController.text);
    final int? hari = int.tryParse(hariController.text);

    if (selectedKapasitas.value == null ||
        jumlahArea == null ||
        durasi == null ||
        hari == null) {
      Get.snackbar('ERROR!', 'Semua field harus diisi!');
      return;
    }

    final double watt = selectedKapasitas.value! * 746;
    final double totalWh = watt * jumlahArea * durasi * hari;
    final double kWh = totalWh / 1000;
    final double co2Kg = kWh * 0.85;

    hasilCO2Harian.value = co2Kg / hari;
    hasilCO2Mingguan.value = hasilCO2Harian.value * 7;
    hasilCO2Bulanan.value = co2Kg;
    showResult.value = true;
  }

  double get hasilCO2 {
    switch (selectedTab.value) {
      case 'Hari':
        return hasilCO2Harian.value;
      case 'Minggu':
        return hasilCO2Mingguan.value;
      case 'Bulan':
        return hasilCO2Bulanan.value;
      default:
        return 0.0;
    }
  }
}

class _CustomTextField extends StatelessWidget {
  final String label;
  final bool required;
  final String? hint;
  final String suffix;
  final TextEditingController controller;
  final int maxLength;
  final int? minValue;
  final int? maxValue;
  final String? errorMessageEmpty;
  final String? errorMessageRange;

  const _CustomTextField({
    required this.label,
    this.required = true,
    this.hint,
    required this.suffix,
    required this.controller,
    this.maxLength = 3,
    this.minValue,
    this.maxValue,
    this.errorMessageEmpty,
    this.errorMessageRange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
            text: TextSpan(
                text: label,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
                children: required
                    ? const [
                        TextSpan(
                            text: ' *',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold))
                      ]
                    : [])),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(maxLength)
          ],
          decoration: InputDecoration(
              hintText: hint ?? 'Masukkan $label',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              suffixText: suffix,
              suffixStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFF018D58), width: 1)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFF018D58), width: 1.7)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.red, width: 1)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.red, width: 1.5))),
          validator: (value) {
            if (required && (value == null || value.isEmpty)) {
              return errorMessageEmpty ?? '$label wajib diisi!';
            }

            if (value != null && value.isNotEmpty) {
              final int? number = int.tryParse(value);

              if (number == null) {
                return 'Harus berupa angka!';
              }

              if (minValue != null && number < minValue!) {
                return errorMessageRange ?? 'Minimal $minValue';
              }

              if (maxValue != null && number > maxValue!) {
                return errorMessageRange ?? 'Maksimal $maxValue';
              }
            }

            return null;
          },
        )
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  final ElectricAreaCalculatorController controller;

  const _ResultCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.showResult.value) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF018D58), width: 1),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Jejak Karbonmu',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTabButton('Hari')),
                const SizedBox(width: 8),
                Expanded(child: _buildTabButton('Minggu')),
                const SizedBox(width: 8),
                Expanded(child: _buildTabButton('Bulan')),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Text('${controller.hasilCO2.toStringAsFixed(2)} Kg CO2',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF018D58))),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTabButton(String tab) {
    return Obx(() {
      final bool isSelected = controller.selectedTab.value == tab;

      return InkWell(
        onTap: () {
          controller.selectedTab.value = tab;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF018D58) : Colors.white,
              border: Border.all(color: const Color(0xFF018D58), width: 1),
              borderRadius: BorderRadius.circular(6)),
          child: Center(
            child: Text(
              tab,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color:
                      isSelected ? Colors.white : const Color(0xFF018D58)),
            ),
          ),
        ),
      );
    });
  }
}

class _KapasitasBebanDropdown extends StatelessWidget {
  const _KapasitasBebanDropdown();

  @override
  Widget build(BuildContext context) {
    final ElectricAreaCalculatorController controller = Get.find();

    return DropdownButtonFormField<double>(
      decoration: InputDecoration(
        hintText: 'Pilih kapasitas',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF018D58), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF018D58), width: 1.5),
        ),
      ),
      items: [0.5, 0.75, 1.0, 1.5, 2.0, 2.5, 3.0].map((pk) {
        return DropdownMenuItem(
          value: pk,
          child: Text('$pk'),
        );
      }).toList(),
      onChanged: (value) {
        controller.selectedKapasitas.value = value;
      },
    );
  }
}

class _HeaderFeaturePage extends StatelessWidget {
  const _HeaderFeaturePage();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFFFEFEFE), boxShadow: [
        BoxShadow(blurRadius: 2, offset: Offset(0, 1), color: Colors.black)
      ]),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.to(() => const FeaturePage());
            },
            child: const Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 0, 0, 0),
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          const Text(
            'Kalkulator Jejak Karbon',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Color.fromARGB(255, 0, 0, 0)),
          )
        ],
      ),
    );
  }
}
