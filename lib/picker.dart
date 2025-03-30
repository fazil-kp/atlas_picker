
import 'package:atlas_picker/model/country_model.dart';
import 'package:atlas_picker/pickers/country_picker.dart';
import 'package:atlas_picker/pickers/state_picker.dart';
import 'package:flutter/material.dart';


class Pick {
  static Widget country({required Function(CountryModel) onChanged, Widget? customWidget, int? verticalPadding, int? horizontalPadding, bool? isSearchEnable = true, CountryModel? value, double? height, double? width}) {
    return CountryPicker(onChanged: onChanged, customWidget: customWidget, verticalPadding: verticalPadding, horizontalPadding: horizontalPadding, isSearchEnable: isSearchEnable, value: value, width: width, height: height);
  }

  static Widget state({required String countryName, required Function(StateModel) onChanged, Widget? customWidget, int? verticalPadding, int? horizontalPadding, bool? isSearchEnable = true, bool? pickerEnable = true, String? value}) {
    return StatePicker(countryName: countryName, onChanged: onChanged, customWidget: customWidget, verticalPadding: verticalPadding, horizontalPadding: horizontalPadding, isSearchEnable: isSearchEnable, value: value, pickerEnable: pickerEnable);
  }
}
