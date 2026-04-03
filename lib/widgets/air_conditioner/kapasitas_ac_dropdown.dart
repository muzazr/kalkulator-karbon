import 'package:flutter/material.dart';

class KapasitasAC extends StatelessWidget {
  final double? value;
  final ValueChanged<double?> onChanged;

  const KapasitasAC({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<double>(
      initialValue: value,
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
      items: [0.5, 0.75, 1.0, 1.5, 2.0, 2.5, 3.0]
          .map((pk) => DropdownMenuItem<double>(value: pk, child: Text('$pk')))
          .toList(),
      onChanged: onChanged,
    );
  }
}

