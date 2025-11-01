import 'dart:convert';

import 'package:invoice_list_test/data/datasources/models/models.dart';
import 'package:invoice_list_test/domain/entities/invoice_entity.dart';

class InvoiceDto {
  List<InvoiceModel> invoices;

  InvoiceDto({required this.invoices});
}

class InvoiceModel {
  int id;
  int companyId;
  String number;
  String reference;
  dynamic currency;
  DateTime issuedAt;
  DateTime dueAt;
  InvoiceState state;
  AmountDto taxAmount;
  AmountDto amountWithoutTaxes;
  AmountDto amount;
  AmountDto amountDue;
  AmountDto amountPaid;
  String humanizedAmount;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic sendAt;
  dynamic description;
  ContactDto contact;

  InvoiceModel({
    required this.id,
    required this.companyId,
    required this.number,
    required this.reference,
    required this.currency,
    required this.issuedAt,
    required this.dueAt,
    required this.state,
    required this.taxAmount,
    required this.amountWithoutTaxes,
    required this.amount,
    required this.amountDue,
    required this.amountPaid,
    required this.humanizedAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.sendAt,
    required this.description,
    required this.contact,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companyId': companyId,
      'number': number,
      'reference': reference,
      'currency': currency,
      'issuedAt': issuedAt.millisecondsSinceEpoch,
      'dueAt': dueAt.millisecondsSinceEpoch,
      'state': state,
      'taxAmount': taxAmount.toMap(),
      'amountWithoutTaxes': amountWithoutTaxes.toMap(),
      'amount': amount.toMap(),
      'amountDue': amountDue.toMap(),
      'amountPaid': amountPaid.toMap(),
      'humanizedAmount': humanizedAmount,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'sendAt': sendAt,
      'description': description,
      'contact': contact.toMap(),
    };
  }

  factory InvoiceModel.fromMap(Map<String, dynamic> map) {
    return InvoiceModel(
      id: map['id']?.toInt() ?? 0,
      companyId: map['companyId']?.toInt() ?? 0,
      number: map['number'] ?? '',
      reference: map['reference'] ?? '',
      currency: map['currency'],
      issuedAt: DateTime.parse(map['issued_at']),
      dueAt: DateTime.parse(map['due_at']),
      state: InvoiceStateExtension.fromValue(map['state'] ?? ''),
      taxAmount: AmountDto.fromMap(map['tax_amount']),
      amountWithoutTaxes: AmountDto.fromMap(map['amount_without_taxes']),
      amount: AmountDto.fromMap(map['amount']),
      amountDue: AmountDto.fromMap(map['amount_due']),
      amountPaid: AmountDto.fromMap(map['amount_paid']),
      humanizedAmount: map['humanized_amount'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      sendAt: map['send_at'],
      description: map['description'],
      contact: ContactDto.fromMap(map['contact']),
    );
  }

  String toJson() => json.encode(toMap());

  factory InvoiceModel.fromJson(String source) =>
      InvoiceModel.fromMap(json.decode(source));
}
