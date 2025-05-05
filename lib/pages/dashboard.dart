import 'package:flutter/material.dart';
import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:moneymate/pages/transaction_analysis.dart';
import 'package:moneymate/pages/category_pie_chart.dart';
import 'package:moneymate/pages/transaction_form.dart';
import 'package:moneymate/pages/home.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

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
  String _categoryFilter = 'All'; // Track category filter (All, Income, Expense)

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
  
  // Filter transactions based on selected date
  List<Map<String, dynamic>> getFilteredTransactions() {
    return _transactions.where((tx) {
      final txDate = tx['date'] as DateTime;
      return txDate.year == selectedDate.year && 
             txDate.month == selectedDate.month && 
             txDate.day == selectedDate.day;
    }).toList();
  }
  
  // Filter transactions by category type (All, Income, Expense)
  List<Map<String, dynamic>> getCategoryFilteredTransactions() {
    final dateFiltered = _transactions.where((tx) {
      final txDate = tx['date'] as DateTime;
      return txDate.year == selectedDate.year && 
             txDate.month == selectedDate.month;
    }).toList();
    
    if (_categoryFilter == 'All') {
      return dateFiltered;
    } else if (_categoryFilter == 'Income') {
      return dateFiltered.where((tx) => tx['isExpense'] == false).toList();
    } else { // Expense
      return dateFiltered.where((tx) => tx['isExpense'] == true).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get theme colors for text and icons based on current brightness
    final filteredTransactions = getCategoryFilteredTransactions();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final labelColor = isDarkMode ? Colors.white : Colors.black;
    
    // Get filtered transactions for today
    final todayTransactions = getFilteredTransactions();
    
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
            // Daily Transaction Summary Section
            _buildDailyTransactionSummary(todayTransactions),
            
            const SizedBox(height: 16),
            
            // Category Filter Section
            _buildCategoryFilterSection(textColor),
            
            const SizedBox(height: 16),
            
            // Line chart section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                color: const Color.fromARGB(255, 55, 57, 74),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Flow',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: TransactionAnalysisChart(
                          transactions: _transactions,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Pie chart filter section (Expense/Income)
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
                transactions: getCategoryFilteredTransactions(),
                showExpenses: showExpensePieChart,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Transaction Insights
            _buildTransactionInsights(),
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
              icon: Icon(Icons.analytics),
              label: 'Analytics',
            ),
          ],
        ),
      ),
    );
  }

  // Widget for displaying daily transaction summary
  Widget _buildDailyTransactionSummary(List<Map<String, dynamic>> todayTransactions) {
    final incomeToday = todayTransactions
        .where((tx) => tx['isExpense'] == false)
        .fold(0.0, (sum, tx) => sum + (tx['amount'] as double));
        
    final expenseToday = todayTransactions
        .where((tx) => tx['isExpense'] == true)
        .fold(0.0, (sum, tx) => sum + (tx['amount'] as double));
    
    final balance = incomeToday - expenseToday;
    final formatCurrency = NumberFormat("#,##0", "id_ID");
    
    return Card(
      margin: const EdgeInsets.all(16.0),
      color: const Color.fromARGB(255, 55, 57, 74),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Overview - ${DateFormat('dd MMM yyyy').format(selectedDate)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Income',
                    'Rp ${formatCurrency.format(incomeToday)}',
                    Icons.arrow_upward,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Expense',
                    'Rp ${formatCurrency.format(expenseToday)}',
                    Icons.arrow_downward,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Balance',
                    'Rp ${formatCurrency.format(balance)}',
                    Icons.account_balance_wallet,
                    balance >= 0 ? Colors.blue : Colors.orange,
                  ),
                ),
              ],
            ),
            if (todayTransactions.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Today\'s Transactions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              ...todayTransactions.map((tx) => _buildTransactionItem(tx)),
            ] else ...[
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'No transactions for this date',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  // Widget for building single transaction item
  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final formatCurrency = NumberFormat("#,##0", "id_ID");
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 65, 67, 84),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 85, 87, 104),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.account_balance_wallet,
              color: transaction['isExpense'] ? Colors.red : Colors.green,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['category'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('HH:mm').format(transaction['date']),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${transaction['isExpense'] ? "-" : "+"} Rp ${formatCurrency.format(transaction['amount'])}',
            style: TextStyle(
              color: transaction['isExpense'] ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  
  // Widget for category filter section
  Widget _buildCategoryFilterSection(Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Filter by: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('All'),
            selected: _categoryFilter == 'All',
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  _categoryFilter = 'All';
                });
              }
            },
            selectedColor: const Color.fromARGB(255, 194, 166, 249),
            backgroundColor: const Color.fromARGB(255, 55, 57, 74),
            labelStyle: TextStyle(
              color: _categoryFilter == 'All' ? Colors.white : Colors.white70,
            ),
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Income'),
            selected: _categoryFilter == 'Income',
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  _categoryFilter = 'Income';
                });
              }
            },
            selectedColor: const Color.fromARGB(255, 194, 166, 249),
            backgroundColor: const Color.fromARGB(255, 55, 57, 74),
            labelStyle: TextStyle(
              color: _categoryFilter == 'Income' ? Colors.white : Colors.white70,
            ),
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Expense'),
            selected: _categoryFilter == 'Expense',
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  _categoryFilter = 'Expense';
                });
              }
            },
            selectedColor: const Color.fromARGB(255, 194, 166, 249),
            backgroundColor: const Color.fromARGB(255, 55, 57, 74),
            labelStyle: TextStyle(
              color: _categoryFilter == 'Expense' ? Colors.white : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTransactionInsights() {
    final formatCurrency = NumberFormat("#,##0", "id_ID");
    
    // Calculate insights data
    final monthlyExpenses = _calculateMonthlyExpenses();
    final topCategory = _getTopCategory(true);
    final biggestExpense = _getBiggestTransaction(true);
    final currentMonth = DateFormat('MMMM').format(selectedDate);
    final todayVsAverage = _compareTodayWithAverage();
    
    return Card(
      margin: const EdgeInsets.all(16.0),
      color: const Color.fromARGB(255, 55, 57, 74),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Financial Insights',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            
            // Monthly Spending Progress
            _buildInsightCard(
              title: '$currentMonth Spending',
              icon: Icons.trending_up,
              color: Colors.orange,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rp ${formatCurrency.format(monthlyExpenses)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: monthlyExpenses > 0 ? 0.7 : 0, // Mock budget ratio
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '70% of monthly budget',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Top expense category
            if (topCategory.isNotEmpty)
              _buildInsightCard(
                title: 'Top Expense Category',
                icon: Icons.category,
                color: Colors.purple,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topCategory['category'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${formatCurrency.format(topCategory['amount'])}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${(topCategory['percentage'] as double).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        color: Colors.purple,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
            const SizedBox(height: 12),
            
            // Today vs. Average
            _buildInsightCard(
              title: 'Daily Comparison',
              icon: Icons.compare_arrows,
              color: Colors.teal,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todayVsAverage >= 0 
                              ? 'Above average' 
                              : 'Below average',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          todayVsAverage >= 0
                              ? 'Spending ${todayVsAverage.abs().toStringAsFixed(1)}% more than usual'
                              : 'Spending ${todayVsAverage.abs().toStringAsFixed(1)}% less than usual',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    todayVsAverage >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                    color: todayVsAverage >= 0 ? Colors.red : Colors.green,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Biggest expense
            if (biggestExpense.isNotEmpty)
              _buildInsightCard(
                title: 'Largest Transaction',
                icon: Icons.payment,
                color: Colors.red,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      biggestExpense['category'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${formatCurrency.format(biggestExpense['amount'])}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd MMM yyyy').format(biggestExpense['date']),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInsightCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 65, 67, 84),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  // Calculate monthly expenses
  double _calculateMonthlyExpenses() {
    return _transactions.where((tx) {
      final txDate = tx['date'] as DateTime;
      return tx['isExpense'] == true &&
             txDate.year == selectedDate.year && 
             txDate.month == selectedDate.month;
    }).fold(0.0, (sum, tx) => sum + (tx['amount'] as double));
  }
  
  // Get top expense category with percentage
  Map<String, dynamic> _getTopCategory(bool isExpense) {
    // Filter by month and expense type
    final filteredTx = _transactions.where((tx) {
      final txDate = tx['date'] as DateTime;
      return tx['isExpense'] == isExpense &&
             txDate.year == selectedDate.year && 
             txDate.month == selectedDate.month;
    }).toList();
    
    if (filteredTx.isEmpty) return {};
    
    // Group by category
    final Map<String, double> categoryMap = {};
    double total = 0;
    
    for (var tx in filteredTx) {
      final category = tx['category'] as String;
      final amount = tx['amount'] as double;
      
      categoryMap[category] = (categoryMap[category] ?? 0) + amount;
      total += amount;
    }
    
    // Find the max category
    String topCategory = '';
    double maxAmount = 0;
    
    categoryMap.forEach((category, amount) {
      if (amount > maxAmount) {
        maxAmount = amount;
        topCategory = category;
      }
    });
    
    if (topCategory.isEmpty) return {};
    
    return {
      'category': topCategory,
      'amount': maxAmount,
      'percentage': (maxAmount / total) * 100,
    };
  }
  
  // Get biggest transaction
  Map<String, dynamic> _getBiggestTransaction(bool isExpense) {
    // Filter by month and expense type
    final filteredTx = _transactions.where((tx) {
      final txDate = tx['date'] as DateTime;
      return tx['isExpense'] == isExpense &&
             txDate.year == selectedDate.year && 
             txDate.month == selectedDate.month;
    }).toList();
    
    if (filteredTx.isEmpty) return {};
    
    // Sort by amount (descending)
    filteredTx.sort((a, b) => (b['amount'] as double).compareTo(a['amount'] as double));
    
    return filteredTx.first;
  }
  
  // Compare today's spending with average
  double _compareTodayWithAverage() {
    // Get current month's expenses
    final currentMonthExpenses = _transactions.where((tx) {
      final txDate = tx['date'] as DateTime;
      return tx['isExpense'] == true &&
             txDate.year == selectedDate.year && 
             txDate.month == selectedDate.month;
    }).toList();
    
    if (currentMonthExpenses.isEmpty) return 0;
    
    // Calculate average daily spending this month
    final totalSpending = currentMonthExpenses.fold(0.0, (sum, tx) => sum + (tx['amount'] as double));
    
    // Count unique days with transactions
    final Set<int> daysWithTransactions = {};
    for (var tx in currentMonthExpenses) {
      final txDate = tx['date'] as DateTime;
      daysWithTransactions.add(txDate.day);
    }
    
    final averageDailySpending = daysWithTransactions.isEmpty ? 
        0.0 : totalSpending / daysWithTransactions.length;
    
    // Calculate today's spending
    final todaySpending = getFilteredTransactions()
        .where((tx) => tx['isExpense'] == true)
        .fold(0.0, (sum, tx) => sum + (tx['amount'] as double));
    
    // Return percentage difference
    if (averageDailySpending == 0) return 0;
    return ((todaySpending - averageDailySpending) / averageDailySpending) * 100;
  }
  
  // Widget for building summary card
  Widget _buildSummaryCard(
    String title,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 65, 67, 84),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}