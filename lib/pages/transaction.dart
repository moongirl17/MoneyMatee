import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:moneymate/data/app_db.dart';
import 'package:get_it/get_it.dart';
import 'package:moneymate/data/transaction_db.dart';
import 'package:moneymate/pages/transaction_form.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final db = TransactionDb(GetIt.instance<AppDatabase>());
  final transaction = <TransactionTableData>[];

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  Future<void> getProducts() async {
    try {
      final result = await db.getAllProducts();
      setState(() {
        transaction.clear();
        transaction.addAll(result);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(int id) async {
    try {
      await db.deleteProduct(id);
      await getProducts();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addProduct({
    String category = '',
    DateTime? date,
    int amount = 0,
    bool isExpense = true,
  }) async {
    try {
      final transactions = TransactionTableCompanion(
        date: drift.Value(date ?? DateTime.now()),
        category: drift.Value(category),
        amount: drift.Value(amount),
        // isExpense: drift.Value(isExpense), // Uncomment jika sudah ada di DB
      );
      await db.addProduct(transactions);
      await getProducts();
    } catch (e) {
      print(e);
    }
  }

  Future<void> editProduct({
    required int id,
    String category = '',
    DateTime? date,
    int amount = 0,
    bool isExpense = true,
  }) async {
    try {
      final transactions = TransactionTableCompanion(
        id: drift.Value(id),
        category: drift.Value(category),
        date: drift.Value(date ?? DateTime.now()),
        amount: drift.Value(amount),
        // isExpense: drift.Value(isExpense), // Uncomment jika sudah ada di DB
      );
      await db.updateProduct(transactions);
      await getProducts();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction"),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionForm(),
                ),
              );
              if (result != null) {
                addProduct(
                  category: result['category'],
                  date: result['date'],
                  amount: result['amount'].toInt(),
                  isExpense: result['isExpense'] ?? true,
                );
              }
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: transaction.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, index) {
          // Default sementara karena isExpense belum dari DB
          bool isExpense = true;

          return Card(
            child: ListTile(
              leading: Icon(
                Icons.account_balance_wallet,
                color: isExpense ? Colors.red : Colors.green,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction[index].category,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${isExpense ? "-" : "+"} Rp${transaction[index].amount}',
                    style: TextStyle(
                      color: isExpense ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${transaction[index].date.day}/${transaction[index].date.month}/${transaction[index].date.year}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionForm(
                            category: transaction[index].category,
                            date: transaction[index].date,
                            amount: transaction[index].amount.toString(),
                            isExpense: isExpense,
                          ),
                        ),
                      );
                      if (result != null) {
                        editProduct(
                          id: transaction[index].id,
                          category: result['category'],
                          date: result['date'],
                          amount: int.parse(result['amount'].toString()),
                          isExpense: result['isExpense'] ?? true,
                        );
                      }
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      delete(transaction[index].id);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
