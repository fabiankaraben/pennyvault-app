import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/transaction_view_model.dart';
import '../models/transaction.dart';
import '../utils/constants.dart';

class HistoryView extends StatelessWidget {
  final bool isScrollable;
  const HistoryView({super.key, this.isScrollable = true});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TransactionViewModel>();
    final transactions = viewModel.transactions;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Important for non-scrollable use
      children: [
        Text(
          'History',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (transactions.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text('No transactions yet'),
            ),
          )
        else if (isScrollable)
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return TransactionListItem(transaction: transactions[index]);
              },
            ),
          )
        else
          // Non-scrollable version for mobile single-column view
          Column(
            children: transactions
                .map((t) => TransactionListItem(transaction: t))
                .toList(),
          ),
      ],
    );

    return Padding(padding: const EdgeInsets.all(24), child: content);
  }
}

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency();
    final dateFormat = DateFormat('MMM dd, yyyy');

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.getCategoryColor(
                transaction.category,
              ).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              AppColors.getCategoryIcon(transaction.category),
              color: AppColors.getCategoryColor(transaction.category),
            ),
          ),
          title: Text(
            transaction.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(dateFormat.format(transaction.date)),
          trailing: Text(
            '${transaction.isExpense ? '-' : '+'}${currencyFormat.format(transaction.amount)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: transaction.isExpense
                  ? Colors.redAccent
                  : const Color(0xFF10B981),
            ),
          ),
        ),
      ),
    );
  }
}
