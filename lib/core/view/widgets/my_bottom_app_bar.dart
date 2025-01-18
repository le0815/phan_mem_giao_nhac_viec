import 'dart:developer';

import 'package:flutter/material.dart';

class MyBottomAppBar extends StatelessWidget {
  final List<ImageIcon> items;
  final int selectedIndex;
  final ValueChanged<int> onTap; // Callback to handle taps on items.
  const MyBottomAppBar({
    super.key,
    required this.items,
    required this.onTap,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            items.length,
            (index) {
              return _buildNavItem(items[index], index, context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(ImageIcon icon, int index, BuildContext context) {
    final isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () {
        onTap(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isSelected ? 36 : 28, // Scale up when selected
        height: isSelected ? 36 : 28,
        curve: Curves.linear,
        child: ImageIcon(
          icon.image,
          color: isSelected ? Theme.of(context).primaryColor : Colors.black,
        ),
      ), // Pass the index to the onTap callback
    );
  }
}
