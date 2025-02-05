// ignore_for_file: deprecated_member_use

import 'package:atlas_picker/elements/country_list.dart';
import 'package:atlas_picker/elements/picker_helper.dart';
import 'package:atlas_picker/elements/smart_overlay.dart';
import 'package:atlas_picker/model/country_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CountryPickerNew extends HookWidget {
  final Function(CountryModel) onChanged;
  final Widget? customWidget;
  final int? verticalPadding;
  final int? horizontalPadding;
  final bool? isSearchEnable;
  final Color? searchBoarderColor;
  final PickerType pickerType;
  const CountryPickerNew(
      {super.key,
      required this.pickerType,
      this.searchBoarderColor,
      required this.onChanged,
      this.customWidget,
      this.verticalPadding,
      this.horizontalPadding,
      this.isSearchEnable = true});

  @override
  Widget build(BuildContext context) {
    final filteredCountries =
        useState<List<CountryModel>>(ListOfCountries.listOfCountries);
    final selectedCountry = useState<CountryModel?>(null);
    final searchText = useState("");
    final searchFocus = useFocusNode();

    void searchCountries(String value) {
      searchText.value = value;
      if (value.isEmpty) {
        filteredCountries.value = ListOfCountries.listOfCountries;
      } else {
        filteredCountries.value = ListOfCountries.listOfCountries
            .where((country) =>
                (country.name).toLowerCase().contains(value.toLowerCase()) ||
                (country.code).toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    }

    return SmartOverlay(
      verticalPadding: verticalPadding ?? -50,
      horizontalPadding: horizontalPadding,
      child: (open) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => {searchText.value = '', open.call()},
          child: customWidget ??
              Container(
                height: 45,
                width: 210,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(selectedCountry.value?.name ?? 'Select a country',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    const Spacer(),
                    const Icon(Icons.keyboard_arrow_down_outlined,
                        size: 24, color: Colors.black),
                  ],
                ),
              ),
        ),
      ),
      onOpened: () => searchFocus.requestFocus(),
      overlayContent: (close) => Container(
        width: PickerTypeUiWidth().buildPickerTypeWidth(pickerType),
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 0,
                offset: const Offset(0, 2))
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            if (isSearchEnable == true)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 35,
                  child: TextFormField(
                    cursorOpacityAnimates: false,
                    cursorHeight: 13,
                    focusNode: searchFocus,
                    initialValue: searchText.value,
                    onChanged: searchCountries,
                    decoration: InputDecoration(
                      hoverColor: Colors.white,
                      focusColor: Colors.white,
                      fillColor: Colors.white,
                      hintText: 'Search Country',
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 13),
                      prefixIcon: PickerTypeSearch()
                                  .buildPickerTypeSearch(pickerType) ==
                              true
                          ? const Icon(Icons.search,
                              color: Colors.grey, size: 20)
                          : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade200)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color:
                                  searchBoarderColor ?? Colors.red.shade300)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 16),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredCountries.value.length,
                itemBuilder: (context, index) {
                  final country = filteredCountries.value[index];
                  final isSelected = selectedCountry.value == country;
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        if (selectedCountry.value == country) {
                          selectedCountry.value = null;
                          onChanged.call(const CountryModel(
                              name: '',
                              code: '',
                              flag: '',
                              shortName: '',
                              phoneNumberLength: 0,
                              states: []));
                          filteredCountries.value =
                              ListOfCountries.listOfCountries;
                        } else {
                          selectedCountry.value = country;
                          onChanged.call(country);
                        }
                        close.call();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.grey.shade300
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 8),
                          child: PickerTypeUi()
                              .buildPickerTypeWidget(pickerType, country),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum PickerType {
  normal,
  all,
  flagOnly,
  codeOnly,
  nameOnly,
  flagAndName,
  shortNameOnly,
  flagAndShortName,
  flagAndCode,
  codeAndName
}
