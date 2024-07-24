import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'expense.dart';
import 'edit_expense_screen.dart'; // Import the EditExpenseScreen

class ExpenseListScreen extends StatefulWidget {
  @override
  _ExpenseListScreenState createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  late Future<List<Expense>> _futureExpenses;

  @override
  void initState() {
    super.initState();
    _futureExpenses = dbHelper.getExpenses();
  }

  Future<void> _deleteExpense(BuildContext context, int id) async {
    // Confirm deletion
    bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this expense?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // Perform the deletion
      await dbHelper.deleteExpense(id);
      // Refresh the list
      setState(() {
        _futureExpenses = dbHelper.getExpenses();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Expense deleted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expense List')),
      body: FutureBuilder<List<Expense>>(
        future: _futureExpenses,
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
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditExpenseScreen(expense: expense),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(expense.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${expense.amount} - ${expense.category}'),
                        SizedBox(height: 4),
                        Text('${expense.date.toLocal()}'),// Handle null
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () => _deleteExpense(context, expense.id!),
                        ),

                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
