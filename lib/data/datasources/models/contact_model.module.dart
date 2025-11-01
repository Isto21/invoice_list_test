import 'dart:convert';

class ContactDto {
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

  ContactDto({
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'website': website,
      'actsAsCostumer': actsAsCostumer,
      'actsAsSupplier': actsAsSupplier,
      'companyNumber': companyNumber,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory ContactDto.fromMap(Map<String, dynamic> map) {
    return ContactDto(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      website: map['website'] ?? '',
      actsAsCostumer: map['acts_as_costumer'] ?? false,
      actsAsSupplier: map['acts_as_supplier'] ?? false,
      companyNumber: map['company_number'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      logo: map['logo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactDto.fromJson(String source) =>
      ContactDto.fromMap(json.decode(source));
}
