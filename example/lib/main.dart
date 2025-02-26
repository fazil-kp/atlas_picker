import 'package:atlas_picker/model/country_model.dart';
import 'package:atlas_picker/picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text('Country & State Picker Example')),
        body: const ExamplesScreen(),
      ),
    );
  }
}




class ExamplesScreen extends HookWidget {
  const ExamplesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedCountry = useState<CountryModel?>(null);
    final selectedState = useState<StateModel?>(null);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Pick.country(
            // pickerType: PickerType.flagOnly,
            onChanged: (CountryModel country) {
              selectedCountry.value = country;
              selectedState.value = null;
            },
          ),
          const SizedBox(height: 16),
          if (selectedCountry.value != null)
            Pick.state(
              countryName: selectedCountry.value?.name ?? "",
              onChanged: (StateModel state) {
                selectedState.value = state;
              },
            ),
          const SizedBox(height: 16),
          if (selectedCountry.value != null && selectedState.value != null)
            Text(
              'Selected Country: ${selectedCountry.value!.name}, Selected State: ${selectedState.value!.name}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}
