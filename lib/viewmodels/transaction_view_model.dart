import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/database_service.dart';

class TransactionViewModel extends ChangeNotifier {
  final DatabaseService _databaseService;
  List<Transaction> _transactions = [];

  TransactionViewModel(this._databaseService) {
    _loadTransactions();
  }

  List<Transaction> get transactions => _transactions;

  double get totalBalance {
    return _transactions.fold(
      0,
      (sum, item) => sum + (item.isExpense ? -item.amount : item.amount),
    );
  }

  double get monthlyIncome {
    final now = DateTime.now();
    return _transactions
        .where(
          (t) =>
              !t.isExpense &&
              t.date.month == now.month &&
              t.date.year == now.year,
        )
        .fold(0, (sum, item) => sum + item.amount);
  }

  double get monthlyExpense {
    final now = DateTime.now();
    return _transactions
        .where(
          (t) =>
              t.isExpense &&
              t.date.month == now.month &&
              t.date.year == now.year,
        )
        .fold(0, (sum, item) => sum + item.amount);
  }

  Map<TransactionCategory, double> get categoryExpenses {
    final now = DateTime.now();
    final expenseMap = <TransactionCategory, double>{};

    for (var t in _transactions.where(
      (t) =>
          t.isExpense && t.date.month == now.month && t.date.year == now.year,
    )) {
      expenseMap[t.category] = (expenseMap[t.category] ?? 0) + t.amount;
    }

    return expenseMap;
  }

  void _loadTransactions() {
    _transactions = _databaseService.getAllTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _databaseService.addTransaction(transaction);
    _loadTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    await _databaseService.deleteTransaction(id);
    _loadTransactions();
  }
}
