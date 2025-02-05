// ignore_for_file: deprecated_member_use

import 'package:atlas_picker/elements/country_list.dart';
import 'package:atlas_picker/elements/smart_overlay.dart';
import 'package:atlas_picker/model/country_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StatePickerNew extends HookWidget {
  final String countryName;
  final Function(StateModel) onChanged;
  final Widget? customWidget;
  final int? verticalPadding;
  final int? horizontalPadding;
  final bool? isSearchEnable;
  final Color? searchBoarderColor;

  const StatePickerNew(
      {super.key,
      required this.countryName,
      this.searchBoarderColor,
      required this.onChanged,
      this.customWidget,
      this.verticalPadding,
      this.horizontalPadding,
      this.isSearchEnable = true});

  @override
  Widget build(BuildContext context) {
    final country = CountryList.countryList.firstWhere(
        (c) => c.name == countryName,
        orElse: () => const CountryModel(
            states: [],
            name: '',
            code: '',
            flag: '',
            shortName: '',
            phoneNumberLength: 0));
    final searchText = useState("");
    final searchFocus = useFocusNode();
    final filteredStates = useState<List<StateModel>>(country.states);
    final selectedState = useState<StateModel?>(null);

    void searchStates(String value) {
      searchText.value = value;
      filteredStates.value = country.states
          .where((state) =>
              state.name.toLowerCase().contains(value.toLowerCase()) == true)
          .toList();
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
                    Text(selectedState.value?.name ?? 'Select a state',
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
        width: 210,
        height: 300,
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
                    onChanged: searchStates,
                    decoration: InputDecoration(
                      hoverColor: Colors.white,
                      focusColor: Colors.white,
                      fillColor: Colors.white,
                      hintText: 'Search State',
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 13),
                      prefixIcon: const Icon(Icons.search,
                          color: Colors.grey, size: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color:
                                  searchBoarderColor ?? Colors.red.shade200)),
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
                itemCount: filteredStates.value.length,
                itemBuilder: (context, index) {
                  final state = filteredStates.value[index];
                  final isSelected = selectedState.value == state;
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        if (selectedState.value == state) {
                          selectedState.value = null;
                          onChanged.call(const StateModel(name: ''));
                          filteredStates.value = country.states;
                        } else {
                          selectedState.value = state;
                          onChanged.call(state);
                        }
                        close.call();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        child: Container(
                          decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.grey.shade300
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 8),
                          child: Text(state.name,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis),
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
