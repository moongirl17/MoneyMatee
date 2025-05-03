import 'package:flutter/material.dart';

class TransactionSummary extends StatelessWidget {
  final List<Map<String, dynamic>> summarydata;

  const TransactionSummary({super.key, required this.summarydata});

  @override
  Widget build(BuildContext context) {
    final totalIncome = summarydata
        .where((tx) => tx['isExpense'] == false)
        .fold(0.0, (sum, tx) => sum + tx['amount']);

    final totalExpense = summarydata
        .where((tx) => tx['isExpense'] == true)
        .fold(0.0, (sum, tx) => sum + tx['amount']);

    // Menentukan warna background berdasarkan tema (dark/light mode)
    Color backgroundColor;
    if (Theme.of(context).brightness == Brightness.dark) {
      backgroundColor = const Color.fromARGB(255, 55, 57, 74); // Dark mode color
    } else {
      backgroundColor = const Color.fromARGB(255, 194, 166, 249); // Light mode color
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,  // Menggunakan warna sesuai tema
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Income Section
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.account_balance_wallet,
                      color: Colors.green, size: 15),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Income',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Rp. ${totalIncome.toStringAsFixed(0)}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),

            // Outcome Section
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.account_balance_wallet,
                      color: Colors.red, size: 15),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Outcome',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Rp. ${totalExpense.toStringAsFixed(0)}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
