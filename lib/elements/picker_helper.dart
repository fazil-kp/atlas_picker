import 'package:atlas_picker/model/country_model.dart';
import 'package:atlas_picker/pickers/country_picker_new.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/widgets.dart';

class PickerTypeUi {
  Widget buildPickerTypeWidget(PickerType pickerType, CountryModel country) {
    switch (pickerType) {
      case PickerType.flagOnly:
        return Padding(padding: const EdgeInsets.only(right: 8.0), child: CountryFlag.fromCountryCode(country.shortName, shape: const Circle(), width: 40, height: 40));
      case PickerType.codeOnly:
        return Center(child: Padding(padding: const EdgeInsets.only(right: 8.0), child: Text(country.code, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))));
      case PickerType.nameOnly:
        return Text(country.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis);
      case PickerType.shortNameOnly:
        return Center(child: Padding(padding: const EdgeInsets.only(right: 8.0), child: Text(country.shortName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)));
      case PickerType.flagAndName:
        return Row(
          children: [
            CountryFlag.fromCountryCode(country.shortName, shape: const Circle(), width: 18, height: 18),
            const SizedBox(width: 5),
            Expanded(child: Text(country.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
          ],
        );
      case PickerType.flagAndShortName:
        return Row(
          children: [
            CountryFlag.fromCountryCode(country.shortName, shape: const Circle(), width: 18, height: 18),
            const SizedBox(width: 5),
            Expanded(child: Text(country.shortName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
          ],
        );
      case PickerType.flagAndCode:
        return Row(
          children: [
            CountryFlag.fromCountryCode(country.shortName, shape: const Circle(), width: 18, height: 18),
            const SizedBox(width: 5),
            Text(country.code, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
          ],
        );
      case PickerType.codeAndName:
        return Row(
          children: [
            Text(country.code, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
            const SizedBox(width: 5),
            Expanded(child: Text(country.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
          ],
        );
      case PickerType.all:
        return Row(
          children: [
            CountryFlag.fromCountryCode(country.shortName, shape: const Circle(), width: 18, height: 18),
            const SizedBox(width: 5),
            Text(country.code, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            const SizedBox(width: 5),
            Text(country.shortName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            const SizedBox(width: 5),
            Expanded(child: Text(country.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
          ],
        );
      case PickerType.normal:
        return Row(
          children: [
            CountryFlag.fromCountryCode(country.shortName, shape: const Circle(), width: 18, height: 18),
            const SizedBox(width: 5),
            Text(country.code, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            const SizedBox(width: 5),
            Expanded(child: Text(country.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
          ],
        );
    }
  }
}

class PickerTypeUiWidth {
  double buildPickerTypeWidth(PickerType pickerType) {
    switch (pickerType) {
      case PickerType.flagOnly:
        return 80;
      case PickerType.codeOnly:
        return 80;
      case PickerType.nameOnly:
        return 210;
      case PickerType.shortNameOnly:
        return 80;
      case PickerType.flagAndName:
        return 210;
      case PickerType.flagAndShortName:
        return 80;
      case PickerType.flagAndCode:
        return 100;
      case PickerType.codeAndName:
        return 210;
      case PickerType.all:
        return 210;
      case PickerType.normal:
        return 210;
    }
  }
}

class PickerTypeSearch {
  bool buildPickerTypeSearch(PickerType pickerType) {
    switch (pickerType) {
      case PickerType.flagOnly:
        return false;
      case PickerType.codeOnly:
        return false;
      case PickerType.nameOnly:
        return true;
      case PickerType.shortNameOnly:
        return false;
      case PickerType.flagAndName:
        return true;
      case PickerType.flagAndShortName:
        return false;
      case PickerType.flagAndCode:
        return false;
      case PickerType.codeAndName:
        return true;
      case PickerType.all:
        return true;
      case PickerType.normal:
        return true;
    }
  }
}
