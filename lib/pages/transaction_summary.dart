import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionSummary extends StatelessWidget {
  final List<Map<String, dynamic>> summarydata;

  const TransactionSummary({
    super.key,
    required this.summarydata,
  });

  @override
  Widget build(BuildContext context) {
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

    final numberFormat = NumberFormat.decimalPattern('id_ID');
    String formatWithRp(num value) => 'Rp${numberFormat.format(value)}';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16), 
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color:  Color.fromARGB(255, 194, 166, 249), 
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance
          const Text(
            'Balance',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatWithRp(balance),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          // Income & Expense in one decorated row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration( 
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildAmountRow(
                  icon: Icons.arrow_upward,
                  title: 'Income',
                  amount: formatWithRp(totalIncome),
                  iconColor: Colors.green,
                ),
                const SizedBox(width: 32), // Spasi antara income dan expense
                _buildAmountRow(
                  icon: Icons.arrow_downward,
                  title: 'Expense',
                  amount: formatWithRp(totalExpense),
                  iconColor: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow({
    required IconData icon,
    required String title,
    required String amount,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
