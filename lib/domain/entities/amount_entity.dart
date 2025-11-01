class AmountEntity {
  int cents;
  String currency;
  String formatted;

  AmountEntity({
    required this.cents,
    required this.currency,
    required this.formatted,
  });
}
