import 'package:atlas_picker/elements/country_list.dart';
import 'package:atlas_picker/elements/country_picker_content.dart';
import 'package:atlas_picker/elements/country_picker_default_ui.dart';
import 'package:atlas_picker/elements/responsive_helper.dart';
import 'package:atlas_picker/elements/smart_overlay.dart';
import 'package:atlas_picker/model/country_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CountryPicker<T> extends HookWidget {
  final Function(CountryModel) onChanged;
  final Widget? customWidget;
  final int? verticalPadding;
  final int? horizontalPadding;
  final double? height;
  final double? width;
  final bool? isSearchEnable;
  final CountryModel? value;

  const CountryPicker({super.key, required this.onChanged, this.height, this.width, this.customWidget, this.verticalPadding, this.horizontalPadding, this.isSearchEnable = true, this.value});

  @override
  Widget build(BuildContext context) {
    final filteredCountries = useState<List<CountryModel>>(CountryList.countryList);
    final selectedCountry = useState<CountryModel?>(value);
    final searchText = useState("");
    final searchFocus = useFocusNode();
    final respo = ResponsiveHelper.isDesktop(context);
    final isOverlayOpen = useState(false);

    void searchCountries(String value) {
      searchText.value = value.trim();
      if (value.isEmpty) {
        filteredCountries.value = CountryList.countryList;
      } else {
        filteredCountries.value = CountryList.countryList.where((country) => (country.name ?? "").toLowerCase().contains(value.toLowerCase()) || (country.code ?? "").toLowerCase().contains(value.toLowerCase())).toList();
      }
    }

    void showBottomSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: .9,
            child: CountryPickerContent(
              filteredCountries: filteredCountries,
              selectedCountry: selectedCountry,
              onSelect: (selected) {
                if (selectedCountry.value == selected) {
                  selectedCountry.value = null;
                  onChanged(CountryModel());
                  filteredCountries.value = CountryList.countryList;
                } else {
                  selectedCountry.value = selected;
                  onChanged(selected);
                }
              },
              isSearchEnable: isSearchEnable!,
              searchFocus: searchFocus,
              searchText: searchText,
              onSearch: searchCountries,
            ),
          );
        },
      );
    }

    return respo
        ? SmartOverlay(
            verticalPadding: verticalPadding ?? -50,
            horizontalPadding: horizontalPadding ?? null,
            child: (open) => MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                  onTap: () {
                    filteredCountries.value = CountryList.countryList;
                    searchText.value = '';
                    open.call();
                    isOverlayOpen.value = true;
                  },
                  child: customWidget ??
                      CountryPickerDefaultUi(
                        value: value,
                        width: width,
                        height: height,
                        isOverlayOpen: isOverlayOpen.value,
                      )),
            ),
            onOpened: () {
              searchFocus.requestFocus();
              isOverlayOpen.value = true;
            },
            // onOutsideTap: () {
            //   isOverlayOpen.value = false;
            // },
            overlayContent: (close) => CountryPickerContent(
              width: width,
              height: height,
              filteredCountries: filteredCountries,
              selectedCountry: selectedCountry,
              onSelect: (selected) {
                if (selectedCountry.value == selected) {
                  selectedCountry.value = null;
                  onChanged(CountryModel());
                  filteredCountries.value = CountryList.countryList;
                } else {
                  selectedCountry.value = selected;
                  onChanged(selected);
                }
                isOverlayOpen.value = false;
                close.call();
              },
              isSearchEnable: isSearchEnable!,
              searchFocus: searchFocus,
              searchText: searchText,
              onSearch: searchCountries,
            ),
          )
        : MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                filteredCountries.value = CountryList.countryList;
                searchText.value = '';
                showBottomSheet.call();
                searchFocus.requestFocus();
              },
              child: customWidget ??
                  CountryPickerDefaultUi(
                    value: value,
                    width: width,
                    height: height,
                    isOverlayOpen: isOverlayOpen.value,
                  ),
            ),
          );
  }
}
