import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_list_test/config/constants/environment.dart';
import 'package:invoice_list_test/config/helpers/utils.dart';
import 'package:invoice_list_test/domain/entities/invoice_entity.dart';
import 'package:invoice_list_test/presentation/providers/filters/filters_provider.riverpod.dart';
import 'package:invoice_list_test/presentation/providers/invoice/invoice_provider.riverpod.dart';
import 'package:invoice_list_test/presentation/widgets/shared/custom_shimmer_effect.dart';
import 'package:invoice_list_test/presentation/widgets/shared/standard_error_page.dart';

class HomeViewPage extends ConsumerStatefulWidget {
  const HomeViewPage({super.key});

  @override
  ConsumerState<HomeViewPage> createState() => _HomeViewPageState();
}

class _HomeViewPageState extends ConsumerState<HomeViewPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(invoiceProvider.notifier).fetchInvoices();
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent - 120) {
      _loadMoreInvoices();
    }
  }

  Future<void> _loadMoreInvoices() async {
    if (_isLoadingMore) return;

    final invoiceP = ref.read(invoiceProvider);

    if (invoiceP.invoices == null ||
        !(invoiceP.invoices?.hasNextPage ?? false)) {
      return;
    }
    setState(() {
      _isLoadingMore = true;
    });

    try {
      await ref.read(invoiceProvider.notifier).loadMoreInvoices();
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final invoiceState = ref.watch(invoiceProvider);

    return RefreshIndicator.adaptive(
      onRefresh: () => ref.read(invoiceProvider.notifier).fetchInvoices(),
      child: (invoiceState.isLoading && invoiceState.invoices == null)
          ? const CustomShimmerEffect(
              listTilesCount: 8,
              height: 80,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            )
          : (invoiceState.error != null && invoiceState.invoices == null)
          ? StandardErrorPage(
              icon: Icons.error_outline,
              firstText: 'Error al cargar las facturas',
              secondText: "Compruebe su conexión",
            )
          : (invoiceState.invoices?.items.isEmpty ?? true)
          ? StandardErrorPage(
              icon: Icons.info,
              firstText: 'No se encontraron facturas',
              secondText: 'Intenta ajustar los filtros de búsqueda',
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildActiveFilters(invoiceState),
                  ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount:
                        invoiceState.invoices!.items.length +
                        (_isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == invoiceState.invoices!.items.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: CustomShimmerEffect(
                            listTilesCount: 1,
                            height: 80,
                          ),
                        );
                      }
                      return _buildInvoiceItem(
                        invoiceState.invoices!.items[index],
                      );
                    },
                  ),
                  if (invoiceState.invoices!.hasNextPage && !_isLoadingMore)
                    _buildLoadMoreIndicator(),
                ],
              ),
            ),
    );
  }

  Widget _buildActiveFilters(InvoiceStatus state) {
    final filters = state.filters;
    final hasActiveFilters =
        filters.state != null ||
        filters.issuedFrom != null ||
        filters.issuedUntil != null;

    if (!hasActiveFilters) return const SizedBox();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Colors.blue[50],
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (filters.state != null)
            Chip(
              label: Text(
                filters.state?.value ?? '',
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
              onDeleted: () {
                ref.read(invoiceFiltersProvider.notifier).deleteStateFilter();
              },
            ),
          if (filters.issuedFrom != null)
            Chip(
              label: Text(
                'Desde: ${convertDate(filters.issuedFrom.toString())}',
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.green[100],
              onDeleted: () {
                ref
                    .read(invoiceFiltersProvider.notifier)
                    .deleteIssuedFromFilter();
              },
            ),
          if (filters.issuedUntil != null)
            Chip(
              label: Text(
                'Hasta: ${convertDate(filters.issuedUntil.toString())}',
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.green[100],
              onDeleted: () {
                ref
                    .read(invoiceFiltersProvider.notifier)
                    .deleteIssuedUntilFilter();
              },
            ),
          TextButton(
            onPressed: () {
              ref.read(invoiceProvider.notifier).clearFilters();
            },
            child: const Text('Limpiar todo', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceItem(InvoiceEntity invoice) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[50],
          radius: 24,
          child: invoice.contact.logo.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    Environment.imageeBaseUrl + invoice.contact.logo,
                    fit: BoxFit.cover,
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        invoice.contact.name.isNotEmpty
                            ? invoice.contact.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      );
                    },
                  ),
                )
              : Text(
                  invoice.contact.name.isNotEmpty
                      ? invoice.contact.name[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
        ),
        title: Text(
          invoice.contact.name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Nº: ${invoice.number}', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 2),
            Text(
              'Emitida: ${convertDate(invoice.issuedAt.toString())}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              invoice.amount.formatted,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: InvoiceStateExtension(invoice.state).color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                InvoiceStateExtension(invoice.state).value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Desliza para cargar más',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_downward, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}
