import 'package:atlas_picker/elements/country_list.dart';
import 'package:atlas_picker/elements/responsive_helper.dart';
import 'package:atlas_picker/elements/smart_overlay.dart';
import 'package:atlas_picker/elements/state_picker_content.dart';
import 'package:atlas_picker/elements/state_picker_default_ui.dart';
import 'package:atlas_picker/model/country_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StatePicker extends HookWidget {
  final String countryName;
  final Function(StateModel) onChanged;
  final Widget? customWidget;
  final int? verticalPadding;
  final int? horizontalPadding;
  final bool? isSearchEnable;
  final bool? pickerEnable;
  final double? height;
  final double? width;
  final String? value;

  const StatePicker({
    super.key,
    required this.countryName,
    required this.onChanged,
    this.height,
    this.width,
    this.customWidget,
    this.verticalPadding,
    this.horizontalPadding,
    this.isSearchEnable = true,
    this.pickerEnable = true,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final country = CountryList.countryList.firstWhere((c) => c.name == countryName, orElse: () => const CountryModel(states: []));
    final searchText = useState("");
    final searchFocus = useFocusNode();
    final filteredStates = useState<List<StateModel>>(List.from(country.states ?? []));
    final selectedState = useState<StateModel?>(null);
    final respo = ResponsiveHelper.isDesktop(context);
    final isOverlayOpen = useState(false);

    void showBottomSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: .9,
            child: StatePickerContent(
              states: country.states ?? [],
              onStateSelected: onChanged,
              isSearchEnable: isSearchEnable ?? true,
              searchFocus: searchFocus,
              filteredStates: filteredStates,
              selectedState: selectedState,
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
                onTap: pickerEnable ?? true
                    ? () {
                        searchText.value = "";
                        filteredStates.value = List.from(country.states ?? []);
                        open.call();
                        isOverlayOpen.value = true;
                      }
                    : null,
                child: customWidget ?? StatePickerDefaultUi(value: value, isOverlayOpen: isOverlayOpen.value, width: width, height: height),
              ),
            ),
            onOpened: () {
              searchFocus.requestFocus();
              isOverlayOpen.value = true;
            },
            // onOutsideTap: () {
            //   isOverlayOpen.value = false;
            // },
            overlayContent: (close) => StatePickerContent(
              states: country.states ?? [],
              onStateSelected: (selected) {
                onChanged.call(selected);
                isOverlayOpen.value = false;
              },
              isSearchEnable: isSearchEnable ?? true,
              searchFocus: searchFocus,
              filteredStates: filteredStates,
              selectedState: selectedState,
              close: close,
            ),
          )
        : MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                filteredStates.value = List.from(country.states ?? []);
                searchText.value = '';
                showBottomSheet.call();
                searchFocus.requestFocus();
              },
              child: customWidget ?? StatePickerDefaultUi(value: value, width: width, height: height, isOverlayOpen: isOverlayOpen.value),
            ),
          );
  }
}
