import 'package:flutter/material.dart';

class TransactionChartSection extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final DateTime selectedDate;
  final Widget chart;

  const TransactionChartSection({
    super.key, 
    required this.transactions,
    required this.selectedDate,
    required this.chart, required bool showExpensePieChart,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate monthly totals
    final monthlyIncome = _calculateMonthlyIncome();
    final monthlyExpense = _calculateMonthlyExpense();
    final balance = monthlyIncome - monthlyExpense;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Financial Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        
        // Monthly summary cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _buildSummaryCard(
                context,
                'Income',
                'Rp ${monthlyIncome.toStringAsFixed(0)}',
                Icons.arrow_upward,
                Colors.green,
              ),
              const SizedBox(width: 12),
              _buildSummaryCard(
                context,
                'Expense',
                'Rp ${monthlyExpense.toStringAsFixed(0)}',
                Icons.arrow_downward,
                Colors.red,
              ),
              const SizedBox(width: 12),
              _buildSummaryCard(
                context,
                'Balance',
                'Rp ${balance.toStringAsFixed(0)}',
                Icons.account_balance_wallet,
                balance >= 0 ? Colors.blue : Colors.orange,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Chart legend
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _buildLegendItem('Income', Colors.green),
              const SizedBox(width: 16),
              _buildLegendItem('Expense', Colors.red),
            ],
          ),
        ),
        
        // Chart
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          height: 250,
          child: chart,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 55, 57, 74),
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
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  double _calculateMonthlyIncome() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    
    return transactions
        .where((tx) => 
            !tx['isExpense'] && 
            tx['date'].isAfter(startOfMonth) &&
            tx['date'].isBefore(now.add(const Duration(days: 1))))
        .fold(0.0, (sum, tx) => sum + tx['amount']);
  }

  double _calculateMonthlyExpense() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    
    return transactions
        .where((tx) => 
            tx['isExpense'] && 
            tx['date'].isAfter(startOfMonth) &&
            tx['date'].isBefore(now.add(const Duration(days: 1))))
        .fold(0.0, (sum, tx) => sum + tx['amount']);
  }
}