import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:moneymate/pages/transaction_chart_section.dart';
import 'package:moneymate/pages/transaction_analysis.dart';
import 'package:moneymate/pages/category_pie_chart.dart';
import 'package:moneymate/pages/transaction_form.dart';
import 'package:moneymate/pages/home.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;

  const DashboardPage({
    super.key, 
    required this.transactions,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime selectedDate = DateTime.now();
  bool showExpensePieChart = true;
  int _selectedIndex = 1; // Set to Dashboard tab initially 
  late List<Map<String, dynamic>> _transactions;

  @override
  void initState() {
    super.initState();
    // Create a copy of the transactions list to work with
    _transactions = List.from(widget.transactions);
  }

  void _onItemTapped(int index) {
    if (index == 0 && _selectedIndex != index) {
      // Navigate to Home page with updated transactions
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home(initialTransactions: _transactions)),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Helper method to format the amount with thousand separator
  String formatAmount(double amount) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    // Get theme colors for text and icons based on current brightness
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final labelColor = isDarkMode ? Colors.white : Colors.black;
    
    return Scaffold(
      appBar: CalendarAppBar(
        accent: const Color.fromARGB(255, 194, 166, 249),
        backButton: false,
        onDateChanged: (date) {
          setState(() {
            selectedDate = date;
          });
        },
        firstDate: DateTime.now().subtract(const Duration(days: 30)),
        lastDate: DateTime.now().add(const Duration(days: 30)),
        // Apply text color according to theme
        locale: 'en',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Line chart section
            TransactionChartSection(
              transactions: _transactions,
              selectedDate: selectedDate,
              chart: TransactionAnalysisChart(
                transactions: _transactions,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Toggle for pie chart (Expense/Income)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: Text(
                      'Expenses',
                      style: TextStyle(
                        color: showExpensePieChart ? Colors.white : textColor.withOpacity(0.7),
                      ),
                    ),
                    selected: showExpensePieChart,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          showExpensePieChart = true;
                        });
                      }
                    },
                    selectedColor: const Color.fromARGB(255, 194, 166, 249),
                    backgroundColor: isDarkMode 
                        ? const Color.fromARGB(255, 55, 57, 74)
                        : Colors.grey[300],
                  ),
                  const SizedBox(width: 16),
                  ChoiceChip(
                    label: Text(
                      'Income',
                      style: TextStyle(
                        color: !showExpensePieChart ? Colors.white : textColor.withOpacity(0.7),
                      ),
                    ),
                    selected: !showExpensePieChart,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          showExpensePieChart = false;
                        });
                      }
                    },
                    selectedColor: const Color.fromARGB(255, 194, 166, 249),
                    backgroundColor: isDarkMode 
                        ? const Color.fromARGB(255, 55, 57, 74)
                        : Colors.grey[300],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Pie chart section with proper theming
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CategoryPieChart(
                transactions: _transactions,
                showExpenses: showExpensePieChart,
              ),
            ),
          ],
        ),
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
            
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Transaction added successfully')),
            );
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

  List<Map<String, dynamic>> _processCategoryData() {
    // Filter transactions based on the selected date
    final filteredTransactions = _transactions.where((transaction) {
      final transactionDate = transaction['date'] is DateTime
          ? transaction['date'] as DateTime // Directly use DateTime if it's already DateTime
          : DateTime.parse(transaction['date']); // Parse it if it's a String

      return transactionDate.year == selectedDate.year &&
             transactionDate.month == selectedDate.month;
    }).toList();

    // Group transactions by category and calculate total amount for each category
    final Map<String, double> categoryTotals = {};
    for (var transaction in filteredTransactions) {
      final category = transaction['category'];
      final amount = transaction['amount'];
      if (categoryTotals.containsKey(category)) {
        categoryTotals[category] = categoryTotals[category]! + amount;
      } else {
        categoryTotals[category] = amount;
      }
    }

    // Convert to a list of maps for easier processing in the pie chart
    return categoryTotals.entries.map((entry) {
      return {'category': entry.key, 'total': entry.value};
    }).toList();
  }
}
