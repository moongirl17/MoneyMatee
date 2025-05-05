import 'package:flutter/material.dart';
import 'package:moneymate/pages/dashboard.dart';
import 'package:moneymate/pages/transaction_form.dart';
import 'package:moneymate/pages/transaction_summary.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneymate/theme/theme_cubit.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, dynamic>> _transactions = [];
  String _filterType = 'All';
  int _selectedIndex = 0; // Set to Home tab initially

  void _onItemTapped(int index) {
    if (index == 1 && _selectedIndex != index) {
      // Navigate to Dashboard page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage(transactions: _transactions)),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get theme colors for text and icons based on current brightness
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final iconColor = isDarkMode ? Colors.white : const Color.fromARGB(255, 55, 57, 74);
    
    final filteredTransactions = _filterType == 'All'
        ? _transactions
        : _transactions.where((tx) {
            return _filterType == 'Income' ? tx['isExpense'] == false : tx['isExpense'] == true;
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('MoneyMate'),
        actions: [
          // Theme toggle button with proper icon color
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: iconColor,
                  ),
                  onPressed: () {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                  iconSize: 30,
                  padding: EdgeInsets.zero,
                  splashRadius: 20,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          TransactionSummary(summarydata: _transactions),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transaction History',
                  style: TextStyle(
                    fontSize: 24,
                    color: textColor,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.filter_alt, color: iconColor),
                  color: const Color.fromARGB(255, 55, 57, 74),
                  onSelected: (value) {
                    setState(() {
                      _filterType = value;
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'All', child: Text('All')),
                    const PopupMenuItem(value: 'Income', child: Text('Income')),
                    const PopupMenuItem(value: 'Outcome', child: Text('Outcome')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: filteredTransactions.isEmpty
                ? Center(
                    child: Text(
                      'No transactions yet!',
                      style: TextStyle(
                        fontSize: 24,
                        color: textColor,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = filteredTransactions[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 55, 57, 74),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 209, 205, 205),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.account_balance_wallet,
                                color: transaction['isExpense'] ? Colors.red : Colors.green,
                                size: 24,
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction['category'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${transaction['isExpense'] ? "-" : "+"} Rp.${transaction['amount'].toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: transaction['isExpense'] ? Colors.red : Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '${transaction['date'].day}/${transaction['date'].month}/${transaction['date'].year}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TransactionForm(
                                          category: transaction['category'],
                                          date: transaction['date'],
                                          amount: transaction['amount'].toString(),
                                          isExpense: transaction['isExpense'],
                                        ),
                                      ),
                                    );

                                    if (result != null && result is Map<String, dynamic>) {
                                      setState(() {
                                        _transactions[index] = result;
                                      });
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.white, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      _transactions.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TransactionForm(),
            ),
          );

          if (result != null && result is Map<String, dynamic>) {
            setState(() {
              _transactions.add(result);
            });
          }
        },
        backgroundColor: const Color.fromARGB(255, 194, 166, 249),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 55, 57, 74),
          selectedItemColor: const Color.fromARGB(255, 194, 166, 249),
          unselectedItemColor: isDarkMode ? Colors.white60 : Colors.white60,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
          ],
        ),
      ),
    );
  }
}