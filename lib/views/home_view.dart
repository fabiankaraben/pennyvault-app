import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/settings_view_model.dart';
import 'dashboard_view.dart';
import 'history_view.dart';
import 'widgets/add_transaction_modal.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PennyVault',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: () {
              final settings = context.read<SettingsViewModel>();
              if (Theme.of(context).brightness == Brightness.dark) {
                settings.setThemeMode(ThemeMode.light);
              } else {
                settings.setThemeMode(ThemeMode.dark);
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            // Desktop/Tablet split view
            return Row(
              children: [
                const Expanded(flex: 3, child: DashboardView()),
                VerticalDivider(width: 1, color: Colors.grey.withOpacity(0.2)),
                const Expanded(flex: 2, child: HistoryView()),
              ],
            );
          } else {
            // Mobile single column - use a single scrollable
            return const SingleChildScrollView(
              child: Column(
                children: [
                  DashboardView(isScrollable: false),
                  Divider(),
                  HistoryView(isScrollable: false),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: HoverScaleFAB(
        onPressed: () => _showAddTransaction(context),
      ),
    );
  }

  void _showAddTransaction(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    if (isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const AddTransactionModal(),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: const SizedBox(width: 500, child: AddTransactionModal()),
        ),
      );
    }
  }
}

class HoverScaleFAB extends StatefulWidget {
  final VoidCallback onPressed;
  const HoverScaleFAB({super.key, required this.onPressed});

  @override
  State<HoverScaleFAB> createState() => _HoverScaleFABState();
}

class _HoverScaleFABState extends State<HoverScaleFAB> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _scale = 1.1),
      onExit: (_) => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton.extended(
          onPressed: widget.onPressed,
          icon: const Icon(Icons.add),
          label: const Text('Add Transaction'),
        ),
      ),
    );
  }
}
