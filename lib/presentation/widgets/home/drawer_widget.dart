import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice_list_test/config/constants/consts.dart';
import 'package:invoice_list_test/config/helpers/utils.dart';
import 'package:invoice_list_test/domain/entities/invoice_entity.dart';
import 'package:invoice_list_test/presentation/providers/filters/filters_provider.riverpod.dart';

class FiltersDrawer extends ConsumerWidget {
  const FiltersDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceStatus = ref.watch(invoiceFiltersProvider);
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Filtros",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                "Estado",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<InvoiceState>(
                  value: invoiceStatus.invoiceState,
                  isExpanded: true,
                  underline: const SizedBox(),
                  hint: const Text("Seleccionar estado"),
                  items: List.generate(
                    InvoiceState.values.length,
                    (index) => DropdownMenuItem(
                      value: InvoiceState.values[index],
                      child: Text(InvoiceState.values[index].value),
                    ),
                  ),
                  onChanged: (value) {
                    ref.read(invoiceFiltersProvider.notifier).setState(value);
                  },
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                "Rango de Fechas",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => _showDatePicker(context, true, ref),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black87,
                            backgroundColor: Colors.grey[50],
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.calendar_today, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                invoiceStatus.issuedFrom == null
                                    ? 'Desde'
                                    : convertDate(
                                        invoiceStatus.issuedFrom.toString(),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextButton(
                          onPressed: () => _showDatePicker(context, false, ref),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black87,
                            backgroundColor: Colors.grey[50],
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.calendar_today, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                invoiceStatus.issuedUntil == null
                                    ? 'Hasta'
                                    : convertDate(
                                        invoiceStatus.issuedUntil.toString(),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: ref
                          .read(invoiceFiltersProvider.notifier)
                          .clearFiltersAndRefresh,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      child: const Text("Limpiar"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(invoiceFiltersProvider.notifier)
                            .applyFilters();
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ApkConstants.primaryApkColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Aplicar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDatePicker(
    BuildContext context,
    bool isFromDate,
    WidgetRef ref,
  ) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (selectedDate != null) {
      if (isFromDate) {
        ref.read(invoiceFiltersProvider.notifier).setIssuedFrom(selectedDate);
      } else {
        ref.read(invoiceFiltersProvider.notifier).setIssuedUntil(selectedDate);
      }
    }
  }
}
