import 'package:atlas_picker/model/country_model.dart';
import 'package:flutter/material.dart';

class CountryPickerDefaultUi extends StatelessWidget {
  final CountryModel? value;
  final double? height;
  final double? width;
  final bool isOverlayOpen;

  const CountryPickerDefaultUi({super.key, required this.value, this.height, this.width, required this.isOverlayOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 45,
      width: width ?? 210,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(width: isOverlayOpen ? 1.5 : 1, color: isOverlayOpen ? Colors.red : Colors.grey.shade300)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child: Text(((value?.name == null || value?.name == '' || value?.name?.isEmpty == true) ? 'Select a country' : value?.name) ?? 'Select a country', maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 15, fontWeight: FontWeight.w500, color: (value?.name == null || value?.name == '' || value?.name?.isEmpty == true) ? Colors.grey : Colors.black))),
          AnimatedRotation(
            turns: isOverlayOpen ? 0.5 : 0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
            child: Icon(Icons.keyboard_arrow_down_outlined, size: 24, color: (value?.name == null || value?.name == '' || value?.name?.isEmpty == true) ? Colors.grey : Colors.black),
          ),
        ],
      ),
    );
  }
}
