class Expense {
  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;

  Expense({this.id, required this.title, required this.amount, required this.date, required this.category});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
    };
  }
}
