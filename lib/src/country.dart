import 'package:country_picker/src/country_parser.dart';
import 'package:country_picker/src/utils.dart';
import 'package:flutter/material.dart';

import 'country_localizations.dart';

///The country Model that has all the country
///information needed from the [country_picker]
class Country {
  static Country worldWide = Country(
    phoneCode: '',
    countryCode: 'WW',
    e164Sc: -1,
    geographic: false,
    level: -1,
    name: 'World Wide',
    example: '',
    displayName: 'World Wide (WW)',
    displayNameNoCountryCode: 'World Wide',
    e164Key: '',
    phoneMinLength: 0,
    phoneMaxLength: 0,
    startingDigits: [],
  );

  ///The country phone code
  final String phoneCode;

  ///The country code, ISO (alpha-2)
  final String countryCode;
  final int e164Sc;
  final bool geographic;
  final int level;

  ///The country name in English
  final String name;

  ///The country name localized
  late String? nameLocalized;

  ///An example of a telephone number without the phone code
  final String example;

  ///Country name (country code) [phone code]
  final String displayName;

  ///An example of a telephone number with the phone code and plus sign
  final String? fullExampleWithPlusSign;

  ///Country name (country code)

  final String displayNameNoCountryCode;
  final String e164Key;

  ///The minimum length of a phone number for this country
  final int phoneMinLength;

  ///The maximum length of a phone number for this country
  final int phoneMaxLength;

  ///The starting digits that phone numbers in this country typically begin with
  final List<String> startingDigits;

  ///The format pattern for phone numbers (e.g., "### ### ###")
  final String? phoneFormat;

  @Deprecated(
    'The modern term is displayNameNoCountryCode. '
    'This feature was deprecated after v1.0.6.',
  )
  String get displayNameNoE164Cc => displayNameNoCountryCode;

  String? getTranslatedName(BuildContext context) {
    return CountryLocalizations.of(context)
        ?.countryName(countryCode: countryCode);
  }

  Country({
    required this.phoneCode,
    required this.countryCode,
    required this.e164Sc,
    required this.geographic,
    required this.level,
    required this.name,
    this.nameLocalized = '',
    required this.example,
    required this.displayName,
    required this.displayNameNoCountryCode,
    required this.e164Key,
    this.fullExampleWithPlusSign,
    required this.phoneMinLength,
    required this.phoneMaxLength,
    required this.startingDigits,
    this.phoneFormat,
  });

  Country.from({required Map<String, dynamic> json})
      : phoneCode = json['e164_cc'] as String,
        countryCode = json['iso2_cc'] as String,
        e164Sc = json['e164_sc'] as int,
        geographic = json['geographic'] as bool,
        level = json['level'] as int,
        name = json['name'] as String,
        example = json['example'] as String,
        displayName = json['display_name'] as String,
        fullExampleWithPlusSign = json['full_example_with_plus_sign'] as String?,
        displayNameNoCountryCode = json['display_name_no_e164_cc'] as String,
        e164Key = json['e164_key'] as String,
        phoneMinLength = json['phone_min_length'] as int,
        phoneMaxLength = json['phone_max_length'] as int,
        startingDigits = (json['starting_digits'] as List<dynamic>).cast<String>(),
        phoneFormat = json['phone_format'] as String?;

  static Country parse(String country) {
    if (country == worldWide.countryCode) {
      return worldWide;
    } else {
      return CountryParser.parse(country);
    }
  }

  static Country? tryParse(String country) {
    if (country == worldWide.countryCode) {
      return worldWide;
    } else {
      return CountryParser.tryParse(country);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['e164_cc'] = phoneCode;
    data['iso2_cc'] = countryCode;
    data['e164_sc'] = e164Sc;
    data['geographic'] = geographic;
    data['level'] = level;
    data['name'] = name;
    data['example'] = example;
    data['display_name'] = displayName;
    data['full_example_with_plus_sign'] = fullExampleWithPlusSign;
    data['display_name_no_e164_cc'] = displayNameNoCountryCode;
    data['e164_key'] = e164Key;
    data['phone_min_length'] = phoneMinLength;
    data['phone_max_length'] = phoneMaxLength;
    data['starting_digits'] = startingDigits;
    data['phone_format'] = phoneFormat;
    return data;
  }

  bool startsWith(String query, CountryLocalizations? localizations) {
    String _query = query;
    if (query.startsWith("+")) {
      _query = query.replaceAll("+", "").trim();
    }
    return phoneCode.startsWith(_query.toLowerCase()) ||
        name.toLowerCase().startsWith(_query.toLowerCase()) ||
        countryCode.toLowerCase().startsWith(_query.toLowerCase()) ||
        (localizations
                ?.countryName(countryCode: countryCode)
                ?.toLowerCase()
                .startsWith(_query.toLowerCase()) ??
            false);
  }

  bool get iswWorldWide => countryCode == Country.worldWide.countryCode;

  @override
  String toString() => 'Country(countryCode: $countryCode, name: $name)';

  @override
  bool operator ==(Object other) {
    if (other is Country) {
      return other.countryCode == countryCode;
    }

    return super == other;
  }

  @override
  int get hashCode => countryCode.hashCode;


  bool validatePhoneNumber(String phoneNumber) {
    final int length = phoneNumber.length;
    final bool lengthValid =
        length >= phoneMinLength && length <= phoneMaxLength;
    final bool startingDigitsValid = startingDigits.isEmpty ||
        startingDigits.any((digits) => phoneNumber.startsWith(digits));
    return lengthValid && startingDigitsValid;
  }

  Widget getFlag({double? size}) {
    final firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    final emojiCountyCode =
        String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
    return Text(
      countryCode == 'WW' ? '\uD83C\uDF0D' : emojiCountyCode,
      style: TextStyle(fontSize: size ?? 25),
    );
  }
}
