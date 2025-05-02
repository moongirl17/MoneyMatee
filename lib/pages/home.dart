import 'package:flutter/material.dart';
import 'package:moneymate/pages/transaction_form.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // List untuk menyimpan transaksi
  final List<Map<String, dynamic>> _transactions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MoneyMate'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20), // Jarak vertikal di bawah AppBar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16), // Tambahkan padding
            child: Align(
              alignment: Alignment.centerLeft, // Posisi teks di sisi kiri
              child: Text(
                'Transaction History',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 20), // Jarak antara ikon dan daftar transaksi
          Expanded(
            child: _transactions.isEmpty
                ? const Center(
                    child: Text(
                      'No transactions yet!',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: _transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _transactions[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(
                          padding: const EdgeInsets.all(10), // Jarak di dalam item
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 55, 57, 74), // Background item
                            borderRadius: BorderRadius.circular(20), // Sudut melengkung
                          ),
                          child: ListTile(
                            leading: Icon(
                              transaction['isExpense'] ? Icons.account_balance_wallet : Icons.account_balance_wallet, // Warna ikon putih
                              color: transaction['isExpense'] ? Colors.red : Colors.green,
                            ),
                            title: Text(
                              transaction['category'],
                              style: const TextStyle(color: Colors.white), // Warna teks putih
                            ),
                            subtitle: Text(
                              '${transaction['date'].day}/${transaction['date'].month}/${transaction['date'].year}',
                              style: const TextStyle(color: Colors.white), // Warna teks putih
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                                  onPressed: () {
                                    // Logika untuk edit transaksi
                                    print('Edit transaction: ${transaction['category']}');
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.white, size: 20),
                                  onPressed: () {
                                    // Logika untuk menghapus transaksi
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
          // Navigasi ke halaman TransactionForm dan tunggu data yang dikembalikan
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TransactionForm(),
            ),
          );

          // Jika ada data yang dikembalikan, tambahkan ke daftar transaksi
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
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Color.fromARGB(255, 149, 150, 161)),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard,
                  color: Color.fromARGB(255, 149, 150, 161)),
              label: 'Dashboard',
            ),
          ],
        ),
      ),
    );
  }
}