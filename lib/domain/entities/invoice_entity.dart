import 'package:flutter/material.dart';
import 'package:invoice_list_test/domain/entities/entities.dart';

class InvoiceEntity {
  int id;
  int companyId;
  String number;
  String reference;
  dynamic currency;
  DateTime issuedAt;
  DateTime dueAt;
  InvoiceState state;
  AmountEntity taxAmount;
  AmountEntity amountWithoutTaxes;
  AmountEntity amount;
  AmountEntity amountDue;
  AmountEntity amountPaid;
  String humanizedAmount;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic sendAt;
  dynamic description;
  ContactEntity contact;

  InvoiceEntity({
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
}

enum InvoiceState { draft, awaiting_payment, canceled, paid }

extension InvoiceStateExtension on InvoiceState {
  String get value {
    switch (this) {
      case InvoiceState.awaiting_payment:
        return 'En espera de pago';
      case InvoiceState.canceled:
        return 'Cancelado';
      case InvoiceState.draft:
        return 'Borrador';
      case InvoiceState.paid:
        return 'Pagado';
    }
  }

  String get name {
    switch (this) {
      case InvoiceState.awaiting_payment:
        return 'awaiting_payment';
      case InvoiceState.canceled:
        return 'canceled';
      case InvoiceState.draft:
        return 'draft';
      case InvoiceState.paid:
        return 'paid';
    }
  }

  Color get color {
    switch (this) {
      case InvoiceState.paid:
        return Colors.green;
      case InvoiceState.awaiting_payment:
        return Colors.orange;
      case InvoiceState.draft:
        return Colors.grey;
      case InvoiceState.canceled:
        return Colors.red;
    }
  }

  static InvoiceState fromValue(String value) {
    switch (value) {
      case "awaiting_payment":
        return InvoiceState.awaiting_payment;
      case "canceled":
        return InvoiceState.canceled;
      case "draft":
        return InvoiceState.draft;
      case "paid":
        return InvoiceState.paid;
      default:
        return InvoiceState.awaiting_payment;
    }
  }
}
