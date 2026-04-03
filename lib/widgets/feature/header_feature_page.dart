import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeaderFeaturePage extends StatelessWidget {
  const HeaderFeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFEFEFE),
        boxShadow: [
          BoxShadow(blurRadius: 2, offset: Offset(0, 1), color: Colors.black)
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              context.go('/');
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
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          )
        ],
      ),
    );
  }
}

