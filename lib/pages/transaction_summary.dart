import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionSummary extends StatelessWidget {
  final List<Map<String, dynamic>> summarydata;

  const TransactionSummary({
    Key? key,
    required this.summarydata,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Hitung total income dan expense
    double totalIncome = 0;
    double totalExpense = 0;

    for (var transaction in summarydata) {
      if (transaction['isExpense'] == true) {
        totalExpense += transaction['amount'];
      } else {
        totalIncome += transaction['amount'];
      }
    }

    double balance = totalIncome - totalExpense;

    // Formatter angka: Rp dengan pemisah ribuan titik
    final numberFormat = NumberFormat.decimalPattern('id_ID');
    String formatWithRp(num value) => 'Rp${numberFormat.format(value)}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Financial Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryCard(
                context,
                'Income',
                formatWithRp(totalIncome),
                Colors.green,
              ),
              _buildSummaryCard(
                context,
                'Expense',
                formatWithRp(totalExpense),
                Colors.red,
              ),
              _buildSummaryCard(
                context,
                'Balance',
                formatWithRp(balance),
                balance >= 0 ? Colors.blue : Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String amount,
    Color color,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 55, 57, 74),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
