import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';

class DatabaseService {
  static const String _boxName = 'transactions';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(TransactionCategoryAdapter());
    await Hive.openBox<Transaction>(_boxName);
  }

  Box<Transaction> get _transactionBox => Hive.box<Transaction>(_boxName);

  List<Transaction> getAllTransactions() {
    return _transactionBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _transactionBox.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _transactionBox.delete(id);
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _transactionBox.put(transaction.id, transaction);
  }

  Future<void> clearAll() async {
    await _transactionBox.clear();
  }
}
