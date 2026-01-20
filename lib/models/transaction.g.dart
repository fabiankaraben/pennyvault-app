// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 1;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      id: fields[0] as String,
      title: fields[1] as String,
      amount: fields[2] as double,
      date: fields[3] as DateTime,
      category: fields[4] as TransactionCategory,
      isExpense: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.isExpense);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionCategoryAdapter extends TypeAdapter<TransactionCategory> {
  @override
  final int typeId = 0;

  @override
  TransactionCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionCategory.food;
      case 1:
        return TransactionCategory.transport;
      case 2:
        return TransactionCategory.utilities;
      case 3:
        return TransactionCategory.entertainment;
      case 4:
        return TransactionCategory.shopping;
      case 5:
        return TransactionCategory.health;
      case 6:
        return TransactionCategory.other;
      case 10:
        return TransactionCategory.salary;
      case 11:
        return TransactionCategory.donation;
      case 12:
        return TransactionCategory.investment;
      case 13:
        return TransactionCategory.gift;
      case 14:
        return TransactionCategory.bonus;
      case 15:
        return TransactionCategory.sideHustle;
      default:
        return TransactionCategory.food;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionCategory obj) {
    switch (obj) {
      case TransactionCategory.food:
        writer.writeByte(0);
        break;
      case TransactionCategory.transport:
        writer.writeByte(1);
        break;
      case TransactionCategory.utilities:
        writer.writeByte(2);
        break;
      case TransactionCategory.entertainment:
        writer.writeByte(3);
        break;
      case TransactionCategory.shopping:
        writer.writeByte(4);
        break;
      case TransactionCategory.health:
        writer.writeByte(5);
        break;
      case TransactionCategory.other:
        writer.writeByte(6);
        break;
      case TransactionCategory.salary:
        writer.writeByte(10);
        break;
      case TransactionCategory.donation:
        writer.writeByte(11);
        break;
      case TransactionCategory.investment:
        writer.writeByte(12);
        break;
      case TransactionCategory.gift:
        writer.writeByte(13);
        break;
      case TransactionCategory.bonus:
        writer.writeByte(14);
        break;
      case TransactionCategory.sideHustle:
        writer.writeByte(15);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
