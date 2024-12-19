import 'package:flutter/material.dart';

import '../ultis/add_space.dart';

Row myLegendChart({required String annotation, required Color color}) {
  return Row(
    children: [
      Container(
        width: 32,
        height: 13,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      AddHorizontalSpace(5),
      Text(
        annotation,
        style: const TextStyle(fontSize: 12),
      )
    ],
  );
}
