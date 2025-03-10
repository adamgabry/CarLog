import 'package:car_log/features/car_expenses/models/expense.dart';
import 'package:flutter/material.dart';

const _EXPENSE_NAME_FONT_SIZE = 16.0;
const _LICENSE_PLATE_FONT_SIZE = 14.0;

class ExpenseDetailsWidget extends StatelessWidget {
  final Expense expense;

  const ExpenseDetailsWidget({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          expenseTypeToString(expense.type),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _EXPENSE_NAME_FONT_SIZE,
            color: theme.colorScheme.onSecondaryContainer,
          ),
        ),
        Text(
          "\$${expense.amount % 1 == 0 ? expense.amount.toStringAsFixed(0) : expense.amount}",
          style: TextStyle(
            fontSize: _LICENSE_PLATE_FONT_SIZE,
            color: theme.colorScheme.onSecondaryContainer,
          ),
        ),
      ],
    );
  }
}
