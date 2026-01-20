import 'package:flutter/material.dart';
import '../models/transaction.dart';

class AppColors {
  static const primary = Color(0xFF6366F1);
  static const secondary = Color(0xFF818CF8);

  static Color getCategoryColor(TransactionCategory category) {
    switch (category) {
      // Expenses
      case TransactionCategory.food:
        return Colors.orange;
      case TransactionCategory.transport:
        return Colors.blue;
      case TransactionCategory.utilities:
        return Colors.purple;
      case TransactionCategory.entertainment:
        return Colors.pink;
      case TransactionCategory.shopping:
        return Colors.cyan;
      case TransactionCategory.health:
        return Colors.green;
      case TransactionCategory.other:
        return Colors.grey;
      // Income
      case TransactionCategory.salary:
        return const Color(0xFF10B981); // Emerald green
      case TransactionCategory.donation:
        return Colors.orangeAccent;
      case TransactionCategory.investment:
        return Colors.indigo;
      case TransactionCategory.gift:
        return Colors.redAccent;
      case TransactionCategory.bonus:
        return Colors.amber;
      case TransactionCategory.sideHustle:
        return Colors.teal;
    }
  }

  static IconData getCategoryIcon(TransactionCategory category) {
    switch (category) {
      // Expenses
      case TransactionCategory.food:
        return Icons.restaurant;
      case TransactionCategory.transport:
        return Icons.directions_car;
      case TransactionCategory.utilities:
        return Icons.lightbulb;
      case TransactionCategory.entertainment:
        return Icons.movie;
      case TransactionCategory.shopping:
        return Icons.shopping_bag;
      case TransactionCategory.health:
        return Icons.medical_services;
      case TransactionCategory.other:
        return Icons.more_horiz;
      // Income
      case TransactionCategory.salary:
        return Icons.payments;
      case TransactionCategory.donation:
        return Icons.volunteer_activism;
      case TransactionCategory.investment:
        return Icons.show_chart;
      case TransactionCategory.gift:
        return Icons.card_giftcard;
      case TransactionCategory.bonus:
        return Icons.workspace_premium;
      case TransactionCategory.sideHustle:
        return Icons.add_business;
    }
  }

  static List<TransactionCategory> getCategories(bool isExpense) {
    if (isExpense) {
      return [
        TransactionCategory.food,
        TransactionCategory.transport,
        TransactionCategory.utilities,
        TransactionCategory.entertainment,
        TransactionCategory.shopping,
        TransactionCategory.health,
        TransactionCategory.other,
      ];
    } else {
      return [
        TransactionCategory.salary,
        TransactionCategory.donation,
        TransactionCategory.investment,
        TransactionCategory.gift,
        TransactionCategory.bonus,
        TransactionCategory.sideHustle,
      ];
    }
  }
}
