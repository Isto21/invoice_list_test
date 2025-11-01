// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:invoice_list_test/config/constants/consts.dart';
import 'package:invoice_list_test/config/helpers/utils.dart';
import 'package:invoice_list_test/presentation/providers/invoice/invoice_provider.riverpod.dart';
import 'package:invoice_list_test/presentation/view/home_view_page.dart';
import 'package:invoice_list_test/presentation/widgets/home/drawer_widget.dart';

const duration = Duration(milliseconds: 300);

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Debounce textDebounce = Debounce(milliseconds: 600);
    final canExit = useState(false);
    final scaffoldKey = useRef(GlobalKey<ScaffoldState>());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, s) {
        if (!didPop) {
          if (!canExit.value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("¿Estás seguro de salir?"),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: "ACEPTAR",
                  onPressed: () {
                    exit(0);
                  },
                ),
              ),
            );
            canExit.value = true;
            Future.delayed(const Duration(seconds: 2), () {
              canExit.value = false;
            });
          } else {
            exit(0);
          }
        }
      },
      child: Scaffold(
        key: scaffoldKey.value,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: FilterAndSearchBar(
              onTap: (value) => textDebounce.run(() {
                final valueTrimmed = value.toString().trim();
                ref.read(invoiceProvider.notifier).search(valueTrimmed);
              }),
              onFilterTap: () {
                scaffoldKey.value.currentState?.openEndDrawer();
              },
            ),
          ),
          toolbarHeight: kToolbarHeight + 60,
          automaticallyImplyLeading: false,
          actions: [SizedBox()],
          centerTitle: false,
          title: const Text(
            "Listado de facturas",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        body: const HomeViewPage(),
        endDrawer: const FiltersDrawer(),
      ),
    );
  }
}

class FilterAndSearchBar extends StatelessWidget {
  final Function? onTap;
  final VoidCallback? onFilterTap;

  const FilterAndSearchBar({super.key, this.onTap, this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, size: 24, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) =>
                          (onTap != null) ? onTap!(value) : null,
                      decoration: const InputDecoration(
                        hintText: "Buscar por contacto, número, referencia...",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: ApkConstants.primaryApkColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: onFilterTap,
              icon: const Icon(
                Icons.filter_list,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
