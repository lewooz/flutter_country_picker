import 'package:collection/collection.dart';

import 'country.dart';
import 'res/country_codes.dart';

class CountryService {
  final List<Country> _countries;

  CountryService()
      : _countries =
            countryCodes.map((country) => Country.from(json: country)).toList();

  ///Return list with all countries.
  ///If [prioritizedCountryCodes] is provided, those countries will be shown first.
  List<Country> getAll({List<String>? prioritizedCountryCodes}) {
    if (prioritizedCountryCodes == null || prioritizedCountryCodes.isEmpty) {
      return _countries;
    }

    final prioritizedCodes =
        prioritizedCountryCodes.map((code) => code.toUpperCase()).toList();

    final prioritized = <Country>[];
    final others = <Country>[];

    for (final country in _countries) {
      if (prioritizedCodes.contains(country.countryCode)) {
        prioritized.add(country);
      } else {
        others.add(country);
      }
    }

    // Sort prioritized countries by the order they appear in prioritizedCountryCodes
    prioritized.sort((a, b) {
      return prioritizedCodes.indexOf(a.countryCode) -
          prioritizedCodes.indexOf(b.countryCode);
    });

    return [...prioritized, ...others];
  }

  ///Returns the first country that match the given code.
  Country? findByCode(String? code) {
    final uppercaseCode = code?.toUpperCase();
    return _countries
        .firstWhereOrNull((country) => country.countryCode == uppercaseCode);
  }

  ///Returns the first country that match the given name.
  Country? findByName(String? name) {
    return _countries.firstWhereOrNull((country) => country.name == name);
  }

  ///Returns the first country that match the given phone code.
  Country? findByPhoneCode(String? phoneCode) {
    return _countries
        .firstWhereOrNull((country) => country.phoneCode == phoneCode);
  }

  ///Returns a list with all the countries that match the given codes list.
  List<Country> findCountriesByCode(List<String> codes) {
    final List<String> _codes =
        codes.map((code) => code.toUpperCase()).toList();
    final List<Country> countries = [];
    for (final code in _codes) {
      final Country? country = findByCode(code);
      if (country != null) {
        countries.add(country);
      }
    }
    return countries;
  }

  bool validatePhoneNumber(String phoneNumber, String dialCode) {
    final Country? country = findByCode(dialCode);
    if (country == null) return false;
    final int length = phoneNumber.length;
    final bool lengthValid =
        length >= country.phoneMinLength && length <= country.phoneMaxLength;
    final bool startingDigitsValid = country.startingDigits.isEmpty ||
        country.startingDigits.any((digits) => phoneNumber.startsWith(digits));
    return lengthValid && startingDigitsValid;
  }
}
