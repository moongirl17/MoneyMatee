import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:moneymate/data/app_db.dart';
import 'package:get_it/get_it.dart';
import 'package:moneymate/data/transaction_db.dart';
import 'package:moneymate/pages/transaction_form.dart';


class Transaction extends StatefulWidget {
  const Transaction({super.key});


  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {

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
    int amount= 0,
  }) async {
    try {
      final transactions = TransactionTableCompanion (
        date: Value(date ?? DateTime.now()),
        category: Value(category),
        amount: Value(amount),
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
  }) async {
    try {
      final transactions = TransactionTableCompanion(
        id: Value(id),
        category: Value(category),
        date: Value(date ?? DateTime.now()),
        amount: Value(amount),
      );
      await db.updateProduct(transactions);
      await getProducts(); // Refresh data setelah update
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction"),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionForm(),
                ),
              );
              if(result != null) {
                addProduct(
                  category: result['category'], 
                  date: result['date'],
                  amount: result['amount'],
                 
                );
              }
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: transaction.length,
        separatorBuilder: (_, __) => SizedBox(height: 16), 
        itemBuilder: (_, index) => Card(
          child: ListTile(
            title: Text(transaction[index].category),
            subtitle: Text(transaction[index].amount.toString()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    print('Editing transaction: ${transaction[index]}');
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionForm(
                          category: transaction[index].category,
                          date: transaction[index].date,
                          amount: transaction[index].amount.toInt().toString(),
                        ),
                      ),
                    );
                    if (result != null) {
                      print('Edited data: $result');
                      editProduct(
                        id: transaction[index].id,
                        category: result['category'],
                        date: result['date'],
                        amount: int.parse(result['amount']),
                      );
                    }
                  },
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    delete(transaction[index].id);
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            )
          ),
        ), 
      ),
    );
  }
}




