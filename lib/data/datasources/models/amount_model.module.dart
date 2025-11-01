import 'dart:convert';

class AmountDto {
  int cents;
  String currency;
  String formatted;

  AmountDto({
    required this.cents,
    required this.currency,
    required this.formatted,
  });

  Map<String, dynamic> toMap() {
    return {'cents': cents, 'currency': currency, 'formatted': formatted};
  }

  factory AmountDto.fromMap(Map<String, dynamic> map) {
    return AmountDto(
      cents: map['cents']?.toInt() ?? 0,
      currency: map['currency'] ?? '',
      formatted: map['formatted'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AmountDto.fromJson(String source) =>
      AmountDto.fromMap(json.decode(source));
}
