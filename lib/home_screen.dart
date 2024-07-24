import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'expense.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  double _balance = 0.0;
  bool _isBalanceVisible = false;

  @override
  void initState() {
    super.initState();
    _calculateBalance();
  }

  Future<void> _calculateBalance() async {
    final expenses = await dbHelper.getExpenses();
    double inflows = 0.0;
    double outflows = 0.0;

    for (var expense in expenses) {
      if (expense.category == 'Inflow') {
        inflows += expense.amount;
      } else if (expense.category == 'Outflow') {
        outflows += expense.amount;
      }
    }

    setState(() {
      _balance = inflows - outflows;
    });
  }

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expense Tracker')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 100),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue[900], // Dark blue color
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Balance: ',
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.white, // White text color
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      _isBalanceVisible ? 'Rs. ${_balance.toStringAsFixed(2)}' : '*****',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Colors.white, // White text color
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(
                        _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: _toggleBalanceVisibility,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
