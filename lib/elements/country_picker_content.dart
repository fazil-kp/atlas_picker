import 'package:atlas_picker/elements/responsive_helper.dart';
import 'package:atlas_picker/model/country_model.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moon_design/moon_design.dart';

class CountryPickerContent extends HookWidget {
  final ValueNotifier<List<CountryModel>> filteredCountries;
  final ValueNotifier<CountryModel?> selectedCountry;
  final Function(CountryModel) onSelect;
  final bool isSearchEnable;
  final FocusNode searchFocus;
  final ValueNotifier<String> searchText;
  final double? height;
  final double? width;
  final Function(String) onSearch;

  const CountryPickerContent({
    super.key,
    required this.filteredCountries,
    required this.selectedCountry,
    required this.onSelect,
    required this.isSearchEnable,
    required this.searchFocus,
    required this.searchText,
    required this.onSearch,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final respo = ResponsiveHelper.isDesktop(context);
    final highlightedIndex = useState(-1);
    final scrollController = useScrollController();

    void scrollToHighlightedItem() {
      if (filteredCountries.value.isEmpty || highlightedIndex.value < 0) return;
      scrollController.animateTo(
        highlightedIndex.value * 50.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    void handleKeyboardNavigation(RawKeyEvent event) {
      if (filteredCountries.value.isEmpty) return;

      if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
        highlightedIndex.value = (highlightedIndex.value + 1) % filteredCountries.value.length;
        scrollToHighlightedItem();
      } else if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
        highlightedIndex.value = (highlightedIndex.value - 1 + filteredCountries.value.length) % filteredCountries.value.length;
        scrollToHighlightedItem();
      } else if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
        final selected = filteredCountries.value[highlightedIndex.value];
        onSelect(selected);
        if (!respo) Navigator.pop(context);
      }
    }

    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: respo ? handleKeyboardNavigation : null,
      child: Container(
        width: width ?? (respo ? 210 : MediaQuery.of(context).size.width),
        height: height ?? 300,
        decoration: BoxDecoration(color: Colors.white, borderRadius: !respo ? BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)) : BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, spreadRadius: 0, offset: const Offset(0, 4))], border: Border.all(color: Colors.grey.shade400)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSearchEnable == true)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MoonFormTextInput(
                  hintText: "Search",
                  activeBorderColor: Colors.red,
                  autofocus: true,
                  focusNode: searchFocus,
                  onChanged: (text) {
                    searchText.value = text;
                    onSearch(text);
                  },
                ),
              ),
            Expanded(
              child: ValueListenableBuilder<List<CountryModel>>(
                valueListenable: filteredCountries,
                builder: (context, countries, child) {
                  return ListView.builder(
                    controller: scrollController,
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.zero,
                    itemExtent: 50.0,
                    itemCount: countries.length,
                    itemBuilder: (context, index) {
                      final country = countries[index];
                      final isSelected = selectedCountry.value == country;
                      final isHighlighted = highlightedIndex.value == index;
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            onSelect(country);
                            if (!respo) Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: isSelected
                                    ? Colors.grey.shade400
                                    : isHighlighted
                                        ? respo
                                            ? Colors.grey.shade400
                                            : Colors.white
                                        : Colors.white,
                              ),
                              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 8),
                              child: Row(
                                children: [
                                  CountryFlag.fromCountryCode(country.shortName ?? "", shape: const Circle(), width: 18, height: 18),
                                  const SizedBox(width: 5),
                                  Text(country.code ?? "", style: const TextStyle(fontSize: 12)),
                                  const SizedBox(width: 5),
                                  Expanded(child: Text(country.name ?? "", style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
