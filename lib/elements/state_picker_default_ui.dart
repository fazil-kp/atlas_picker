import 'package:flutter/material.dart';

class StatePickerDefaultUi extends StatelessWidget {
  final String? value;
  final double? height;
  final double? width;
  final bool isOverlayOpen;
  const StatePickerDefaultUi({super.key, required this.value, this.height, this.width, required this.isOverlayOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 45,
      width: width ?? 210,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(width: isOverlayOpen ? 1.5 : 1, color: isOverlayOpen ? Colors.red : Colors.grey.shade400)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(((value == null || value == '' || value?.isEmpty == true) ? 'Select a state' : value) ?? 'Select a state', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 15, fontWeight: FontWeight.w500, color: (value == null || value == '' || value?.isEmpty == true) ? Colors.grey : Colors.black), overflow: TextOverflow.ellipsis)),
          AnimatedRotation(
            turns: isOverlayOpen ? 0.5 : 0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
            child: Icon(Icons.keyboard_arrow_down_outlined, size: 24, color: (value == null || value == '' || value?.isEmpty == true) ? Colors.grey : Colors.black),
          ),
        ],
      ),
    );
  }
}
