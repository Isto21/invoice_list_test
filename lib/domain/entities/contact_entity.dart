class ContactEntity {
  int id;
  String name;
  String email;
  String phone;
  String website;
  bool actsAsCostumer;
  bool actsAsSupplier;
  String companyNumber;
  DateTime createdAt;
  DateTime updatedAt;
  String logo;

  ContactEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.website,
    required this.actsAsCostumer,
    required this.actsAsSupplier,
    required this.companyNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.logo,
  });
}
