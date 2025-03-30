import 'package:atlas_picker/elements/responsive_helper.dart';
import 'package:atlas_picker/model/country_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moon_design/moon_design.dart';

class StatePickerContent extends HookWidget {
  final List<StateModel> states;
  final Function(StateModel) onStateSelected;
  final bool isSearchEnable;
  final FocusNode searchFocus;
  final ValueNotifier<List<StateModel>> filteredStates;
  final ValueNotifier<StateModel?> selectedState;
  final VoidCallback? close;
  final double? height;
  final double? width;

  const StatePickerContent({
    super.key,
    required this.states,
    required this.onStateSelected,
    required this.isSearchEnable,
    required this.searchFocus,
    this.height,
    this.width,
    required this.filteredStates,
    required this.selectedState,
    this.close,
  });

  @override
  Widget build(BuildContext context) {
    final respo = ResponsiveHelper.isDesktop(context);
    final highlightedIndex = useState(-1);
    final scrollController = useScrollController();

    void scrollToHighlightedItem() {
      if (filteredStates.value.isEmpty || highlightedIndex.value < 0) return;
      scrollController.animateTo(
        highlightedIndex.value * 45,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    void handleKeyboardNavigation(RawKeyEvent event) {
      if (filteredStates.value.isEmpty) return;

      if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
        highlightedIndex.value = (highlightedIndex.value + 1) % filteredStates.value.length;
        scrollToHighlightedItem();
      } else if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
        highlightedIndex.value = (highlightedIndex.value - 1 + filteredStates.value.length) % filteredStates.value.length;
        scrollToHighlightedItem();
      } else if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
        final selected = filteredStates.value[highlightedIndex.value];
        onStateSelected(selected);
        close?.call();
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: !respo ? BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)) : BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, spreadRadius: 0, offset: const Offset(0, 4))],
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSearchEnable == true)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MoonFormTextInput(
                  hintText: 'Search',
                  activeBorderColor: Colors.red,
                  autofocus: true,
                  focusNode: searchFocus,
                  onChanged: (value) {
                    filteredStates.value = states.where((state) => state.name?.toLowerCase().contains(value.toLowerCase()) ?? false).toList();
                  },
                ),
              ),
            Expanded(
              child: ValueListenableBuilder<List<StateModel>>(
                valueListenable: filteredStates,
                builder: (context, stateList, child) {
                  return ListView.builder(
                    controller: scrollController,
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.zero,
                    itemExtent: 45.0,
                    itemCount: stateList.length,
                    itemBuilder: (context, index) {
                      final state = stateList[index];
                      final isSelected = selectedState.value == state;
                      final isHighlighted = highlightedIndex.value == index;
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            selectedState.value = state;
                            onStateSelected(state);
                            if (respo) {
                              close?.call();
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                              child: Text(state.name ?? '', style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
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
