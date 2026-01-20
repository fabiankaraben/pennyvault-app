import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../viewmodels/transaction_view_model.dart';
import '../models/transaction.dart';
import '../utils/constants.dart';

class DashboardView extends StatelessWidget {
  final bool isScrollable;
  const DashboardView({super.key, this.isScrollable = true});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TransactionViewModel>();
    final currencyFormat = NumberFormat.simpleCurrency();

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        _SummaryGrid(viewModel: viewModel, currencyFormat: currencyFormat),
        const SizedBox(height: 32),
        Text(
          'Spending Preview',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _SpendingChart(categoryExpenses: viewModel.categoryExpenses),
      ],
    );

    if (isScrollable) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: content,
      );
    } else {
      return Padding(padding: const EdgeInsets.all(24), child: content);
    }
  }
}

class _SummaryGrid extends StatelessWidget {
  final TransactionViewModel viewModel;
  final NumberFormat currencyFormat;

  const _SummaryGrid({required this.viewModel, required this.currencyFormat});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoint for 3 columns: 500px (to allow some space for each card)
        final showThreeColumns = constraints.maxWidth > 500;

        if (!showThreeColumns) {
          return Column(
            children: [
              _SummaryCard(
                title: 'Total Balance',
                amount: currencyFormat.format(viewModel.totalBalance),
                color: AppColors.primary,
                icon: Icons.account_balance_wallet,
              ),
              const SizedBox(height: 12),
              _SummaryCard(
                title: 'Monthly Income',
                amount: currencyFormat.format(viewModel.monthlyIncome),
                color: const Color(0xFF10B981),
                icon: Icons.trending_up,
              ),
              const SizedBox(height: 12),
              _SummaryCard(
                title: 'Monthly Spending',
                amount: currencyFormat.format(viewModel.monthlyExpense),
                color: Colors.redAccent,
                icon: Icons.trending_down,
              ),
            ],
          );
        }

        // Desktop/Tablet: Always 3 columns in a row
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _SummaryCard(
                  title: 'Total Balance',
                  amount: currencyFormat.format(viewModel.totalBalance),
                  color: AppColors.primary,
                  icon: Icons.account_balance_wallet,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  title: 'Monthly Income',
                  amount: currencyFormat.format(viewModel.monthlyIncome),
                  color: const Color(0xFF10B981),
                  icon: Icons.trending_up,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  title: 'Monthly Spending',
                  amount: currencyFormat.format(viewModel.monthlyExpense),
                  color: Colors.redAccent,
                  icon: Icons.trending_down,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize
              .min, // Use min to avoid overflow issues in IntrinsicHeight
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                amount,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpendingChart extends StatefulWidget {
  final Map<TransactionCategory, double> categoryExpenses;

  const _SpendingChart({required this.categoryExpenses});

  @override
  State<_SpendingChart> createState() => _SpendingChartState();
}

class _SpendingChartState extends State<_SpendingChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.categoryExpenses.isEmpty) {
      return const Card(
        child: SizedBox(
          height: 300,
          child: Center(child: Text('No data for this month')),
        ),
      );
    }

    return Card(
      child: Container(
        height: 400, // Increased height for better visualization
        padding: const EdgeInsets.all(24),
        child: PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              },
            ),
            borderData: FlBorderData(show: false),
            sectionsSpace: 4,
            centerSpaceRadius: 60,
            sections: _showingSections(),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _showingSections() {
    return widget.categoryExpenses.entries.map((entry) {
      final isTouched =
          widget.categoryExpenses.keys.toList().indexOf(entry.key) ==
          touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 70.0 : 60.0;
      final color = AppColors.getCategoryColor(entry.key);

      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: isTouched
            ? '${entry.key.name.toUpperCase()}\n\$${entry.value.toStringAsFixed(0)}'
            : '',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: !isTouched
            ? _Badge(
                AppColors.getCategoryIcon(entry.key),
                size: 30,
                borderColor: color,
              )
            : null,
        badgePositionPercentageOffset: .98,
      );
    }).toList();
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color borderColor;

  const _Badge(this.icon, {required this.size, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Icon(icon, size: size * .6, color: borderColor),
      ),
    );
  }
}
