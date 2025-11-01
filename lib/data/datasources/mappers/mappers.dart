import 'package:invoice_list_test/data/datasources/models/models.dart';
import 'package:invoice_list_test/domain/entities/entities.dart';

class Mappers {
  List<InvoiceEntity> invoiceDtoToEntity(List<InvoiceModel> dto) {
    return dto
        .map(
          (invoice) => InvoiceEntity(
            id: invoice.id,
            companyId: invoice.companyId,
            number: invoice.number,
            reference: invoice.reference,
            currency: invoice.currency,
            issuedAt: invoice.issuedAt,
            dueAt: invoice.dueAt,
            state: invoice.state,
            taxAmount: amountDtoToEntity(invoice.taxAmount),
            amountWithoutTaxes: amountDtoToEntity(invoice.amountWithoutTaxes),
            amount: amountDtoToEntity(invoice.amount),
            amountDue: amountDtoToEntity(invoice.amountDue),
            amountPaid: amountDtoToEntity(invoice.amountPaid),
            humanizedAmount: invoice.humanizedAmount,
            createdAt: invoice.createdAt,
            updatedAt: invoice.updatedAt,
            sendAt: invoice.sendAt,
            description: invoice.description,
            contact: contactModelToEntity(invoice.contact),
          ),
        )
        .toList();
  }

  ContactEntity contactModelToEntity(ContactDto contact) {
    return ContactEntity(
      id: contact.id,
      name: contact.name,
      email: contact.email,
      phone: contact.phone,
      website: contact.website,
      actsAsCostumer: contact.actsAsCostumer,
      actsAsSupplier: contact.actsAsSupplier,
      companyNumber: contact.companyNumber,
      createdAt: contact.createdAt,
      updatedAt: contact.updatedAt,
      logo: contact.logo,
    );
  }

  AmountEntity amountDtoToEntity(AmountDto dto) {
    return AmountEntity(
      cents: dto.cents,
      currency: dto.currency,
      formatted: dto.formatted,
    );
  }
}
