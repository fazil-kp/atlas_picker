class CountryModel {
  final String? name;
  final String? code;
  final String? flag;
  final String? shortName;
  final String? currencyName;
  final String? currencySymbol;
  final int? phoneNumberLength;
  final List<StateModel>? states;

  const CountryModel({
    this.name,
    this.code,
    this.flag,
    this.shortName,
    this.currencyName,
    this.currencySymbol,
    this.phoneNumberLength,
    this.states,
  });
}

class StateModel {
  final String name;

  const StateModel({required this.name});
}
