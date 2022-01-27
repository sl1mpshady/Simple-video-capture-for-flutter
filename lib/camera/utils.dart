import 'package:flutter/material.dart';

Widget renderSidetool(
    {required String label, required IconData icon, void Function()? action}) {
  return GestureDetector(
    onTap: () {
      print(label);
      if (action != null) {
        action();
      }
    },
    child: Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          label,
          style: const TextStyle(
              color: Colors.white, fontSize: 8, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    ),
  );
}
