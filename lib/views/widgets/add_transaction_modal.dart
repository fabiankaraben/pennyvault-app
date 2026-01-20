import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/transaction.dart';
import '../../viewmodels/transaction_view_model.dart';
import '../../utils/constants.dart';

class AddTransactionModal extends StatefulWidget {
  const AddTransactionModal({super.key});

  @override
  State<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  late TransactionCategory _selectedCategory;
  bool _isExpense = true;

  @override
  void initState() {
    super.initState();
    _selectedCategory = AppColors.getCategories(true).first;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        category: _selectedCategory,
        isExpense: _isExpense,
      );

      context.read<TransactionViewModel>().addTransaction(transaction);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    // We get the categories list inside build to ensure it's always fresh
    final currentCategories = AppColors.getCategories(_isExpense);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Transaction',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: true,
                  label: Text('Expense'),
                  icon: Icon(Icons.trending_down),
                ),
                ButtonSegment(
                  value: false,
                  label: Text('Income'),
                  icon: Icon(Icons.trending_up),
                ),
              ],
              selected: {_isExpense},
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() {
                  _isExpense = newSelection.first;
                  // Explicitly set the category for the new mode
                  _selectedCategory = AppColors.getCategories(_isExpense).first;
                });
              },
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'e.g., Grocery shopping',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.description_outlined),
              ),
              validator: (val) => val == null || val.isEmpty
                  ? 'Please enter a description'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                hintText: '0.00',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.attach_money),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (val) => val == null || double.tryParse(val) == null
                  ? 'Please enter a valid amount'
                  : null,
            ),
            const SizedBox(height: 24),
            const Text(
              'Category',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            // Replacing ListView with Wrap for better reliability in state updates
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: currentCategories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(
                    cat.name[0].toUpperCase() + cat.name.substring(1),
                    style: TextStyle(
                      color: isSelected ? Colors.white : null,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedCategory = cat);
                    }
                  },
                  selectedColor: _isExpense
                      ? Colors.redAccent
                      : const Color(0xFF10B981),
                  avatar: Icon(
                    AppColors.getCategoryIcon(cat),
                    size: 16,
                    color: isSelected
                        ? Colors.white
                        : AppColors.getCategoryColor(cat),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) setState(() => _selectedDate = date);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('EEEE, MMM dd, yyyy').format(_selectedDate),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isExpense
                    ? Colors.redAccent
                    : const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Save ${_isExpense ? "Expense" : "Income"}',
                style: const TextStyle(
                  fontSize: 16,
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
