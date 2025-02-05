import 'package:atlas_picker/model/country_model.dart';
import 'package:atlas_picker/pickers/country_picker_new.dart';
import 'package:atlas_picker/pickers/state_picker_new.dart';
import 'package:flutter/material.dart';

class Pick {
  static Widget country({
    required Function(CountryModel) onChanged,
    Widget? customWidget,
    int? verticalPadding,
    int? horizontalPadding,
    bool? isSearchEnable = true,
    PickerType pickerType = PickerType.normal,
    Color? searchBoarderColor,
  }) {
    return CountryPickerNew(
      onChanged: onChanged,
      customWidget: customWidget,
      verticalPadding: verticalPadding,
      horizontalPadding: horizontalPadding,
      isSearchEnable: isSearchEnable,
      pickerType: pickerType,
      searchBoarderColor: searchBoarderColor,
    );
  }

  static Widget state({
    required String countryName,
    required Function(StateModel) onChanged,
    Widget? customWidget,
    int? verticalPadding,
    int? horizontalPadding,
    bool? isSearchEnable = true,
    searchBoarderColor,
  }) {
    return StatePickerNew(
      countryName: countryName,
      onChanged: onChanged,
      customWidget: customWidget,
      verticalPadding: verticalPadding,
      horizontalPadding: horizontalPadding,
      isSearchEnable: isSearchEnable,
      searchBoarderColor: searchBoarderColor,
    );
  }
}
