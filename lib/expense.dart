class Expense {
  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final String? description; // New field

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.description, // New field
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'description': description ?? '',
    };
  }

  // Create an Expense object from a map
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      category: map['category'],
      description: map['description'], // New field
    );
  }
}
