import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'select_feature.dart';

class AirConditionerCalculator extends StatelessWidget {
  const AirConditionerCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    final AcCalculatorController controller = Get.put(AcCalculatorController());

    return Scaffold(
      backgroundColor: Color(0xFFFEFEFE),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderFeaturePage(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      'Air Conditioner',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 22),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Kapasitas AC (PK)',
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
                  SizedBox(height: 8), // Jarak antara label dan dropdown
                  KapasitasAC(),
                            
                  //jumlah total pendingin ruangan
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                      label: 'Jumlah Total Air Conditioner',
                      hint: 'Masukkan jumlah total air conditioner',
                      suffix: 'buah',
                      maxValue: 3,
                      minValue: 1,
                      maxLength: 100000,
                      errorMessageEmpty: 'Wajib masukkan jumlah AC!',
                      controller: controller.jumlahACController),
                            
                  //durasi penggunaan AC perhari
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                      label: 'Durasi',
                      hint: 'Masukkan durasi penggunaan',
                      suffix: 'Jam/Hari',
                      maxValue: 24,
                      minValue: 1,
                      maxLength: 100000,
                      errorMessageEmpty: 'Wajib masukkan durasi penggunaan AC!',
                      controller: controller.durasiACController),
                            
                  //penggunaan AC perbulan
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                      label: 'Total Hari Digunakan dalam Sebulan',
                      hint: 'Total Penggunaan dalam Sebulan',
                      suffix: 'Hari',
                      maxValue: 30,
                      minValue: 1,
                      maxLength: 100000,
                      errorMessageEmpty: 'Wajib masukkan hari penggunaan AC!',
                      controller: controller.hariACController),
                            
                  SizedBox(height: 30,),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Text(
                      'Kalkulasi yang digunakan sudah sesuai dengan jurnal dan literatur resmi.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700
                      ),
                    ),
                  ),
                            
                  SizedBox(height: 20,),
                  ResultCard(controller: controller),
                            
                  SizedBox(height: 20,)
                ],
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 4,
                  offset: Offset(0, -2)
                ) 
              ]
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.hitungJejakKarbon(), 
                child: Text(
                  'Hitung',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF018D58),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  )
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}

class CustomTextField extends StatelessWidget {
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

  const CustomTextField({
    Key? key,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
            text: TextSpan(
                text: label,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
                children: required
                    ? [
                        TextSpan(
                            text: ' *',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold))
                      ]
                    : [])),
        SizedBox(
          height: 8,
        ),
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
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFF018D58), width: 1)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFF018D58),
                    width: 1.7,
                  )),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.red, width: 1)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.red, width: 1.5))),
          validator: (value) {
            if (required && (value == null || value.isEmpty)) {
              return errorMessageEmpty ?? '$label wajib diisi!';
            }

            if (value != null && value.isNotEmpty) {
              int? number = int.tryParse(value);

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

class AcCalculatorController extends GetxController {
  final jumlahACController = TextEditingController();
  final durasiACController = TextEditingController();
  final hariACController = TextEditingController();

  var selectedKapasitas = Rxn<double>();

  @override
  void onClose() {
    jumlahACController.dispose();
    durasiACController.dispose();
    hariACController.dispose();
    super.onClose();
  }

  var hasilCO2Harian = 0.0.obs;
  var hasilCO2Mingguan = 0.0.obs;
  var hasilCO2Bulanan = 0.0.obs;
  var selectedTab = 'Hari'.obs;
  var showResult = false.obs;

  void hitungJejakKarbon() {
    String jumlahACText = jumlahACController.text;
    String durasiACText = durasiACController.text;
    String hariACText = hariACController.text;

    int? jumlahAC = int.tryParse(jumlahACText);
    int? durasiAC = int.tryParse(durasiACText);
    int? hariAC = int.tryParse(hariACText);

    if (selectedKapasitas.value == null ||
        jumlahAC == null ||
        durasiAC == null ||
        hariAC == null) {
      Get.snackbar('ERROR!', 'Semua field harus diisi!');
    }

    // Hitung CO2
    double watt = selectedKapasitas.value! * 746;
    double totalWh = watt * jumlahAC! * durasiAC! * hariAC!;
    double kWh = totalWh / 1000;
    double co2Kg = kWh * 0.85;

    hasilCO2Harian.value = co2Kg / hariAC;
    hasilCO2Mingguan.value = hasilCO2Harian * 7;
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

  void reset() {
    jumlahACController.clear();
    durasiACController.clear();
    hariACController.clear();
    selectedKapasitas.value = null;
  }
}

class ResultCard extends StatelessWidget {
  final AcCalculatorController controller;

  const ResultCard({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.showResult.value) {
        return SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xFF018D58), width: 1),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jejak Karbonmu',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTabButton('Hari')),
                SizedBox(
                  height: 8,
                ),
                Expanded(child: _buildTabButton('Minggu')),
                SizedBox(
                  height: 8,
                ),
                Expanded(child: _buildTabButton('Bulan')),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Center(
              child: Text('${controller.hasilCO2.toStringAsFixed(2)} Kg CO2',
                  style: TextStyle(
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
      bool isSelected = controller.selectedTab.value == tab;

      return InkWell(
        onTap: () {
          controller.selectedTab.value = tab;
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF018D58) : Colors.white,
            border: Border.all(
              color: Color(0xFF018D58),
              width: 1
            ),
            borderRadius: BorderRadius.circular(6)
          ),
          child: Center(
            child: Text(
              tab,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Color(0xFF018D58)
              ),
            ),
          ),
        ),
      );
    });
  }
}

class KapasitasAC extends StatelessWidget {
  const KapasitasAC({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AcCalculatorController controller = Get.find();

    return DropdownButtonFormField<double>(
      decoration: InputDecoration(
        // JANGAN pakai labelText atau label
        hintText: 'Pilih kapasitas',
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 14,
        ),

        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Color(0xFF018D58),
            width: 1,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Color(0xFF018D58),
            width: 1.5,
          ),
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

class HeaderFeaturePage extends StatelessWidget {
  const HeaderFeaturePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xFFFEFEFE), boxShadow: [
        BoxShadow(blurRadius: 2, offset: Offset(0, 1), color: Colors.black)
      ]),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.to(() => FeaturePage());
            },
            child: Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 0, 0, 0),
              size: 30,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Text(
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
