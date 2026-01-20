import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
enum TransactionCategory {
  // Expense Categories
  @HiveField(0)
  food,
  @HiveField(1)
  transport,
  @HiveField(2)
  utilities,
  @HiveField(3)
  entertainment,
  @HiveField(4)
  shopping,
  @HiveField(5)
  health,
  @HiveField(6)
  other,

  // Income Categories
  @HiveField(10)
  salary,
  @HiveField(11)
  donation,
  @HiveField(12)
  investment,
  @HiveField(13)
  gift,
  @HiveField(14)
  bonus,
  @HiveField(15)
  sideHustle,
}

@HiveType(typeId: 1)
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final TransactionCategory category;

  @HiveField(5)
  final bool isExpense;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.isExpense = true,
  });
}
