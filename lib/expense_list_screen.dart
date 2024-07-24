import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'expense.dart';

class ExpenseListScreen extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expense List')),
      body: FutureBuilder<List<Expense>>(
        future: dbHelper.getExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No expenses added yet.'));
          } else {
            final expenses = snapshot.data!;
            return ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return ListTile(
                  title: Text(expense.title),
                  subtitle: Text('${expense.amount} - ${expense.category}'),
                  trailing: Text('${expense.date.toLocal()}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
