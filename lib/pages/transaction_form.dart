import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({
    super.key, 
    this.category, 
    this.amount, 
    this.date,
    this.isExpense, // Tambahkan parameter isExpense
  });

  final String? category; // Kategori transaksi
  final String? amount; // Jumlah transaksi
  final DateTime? date; // Tanggal transaksi
  final bool? isExpense; // Status expense, nullable
  
  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  bool isExpense = true; // Default value for the switch
  final TextEditingController _categoryController = TextEditingController(); // Controller untuk kategori
  final TextEditingController _dateController = TextEditingController(); // Controller untuk tanggal
  final TextEditingController _amountController = TextEditingController(); // Controller untuk jumlah
  final _formKey = GlobalKey<FormState>(); // Kunci untuk form
  DateTime? _selectedDate; // Variabel untuk menyimpan tanggal yang dipilih

  @override
  void dispose() {
    _categoryController.dispose(); // Dispose controller saat widget dihapus
    _dateController.dispose(); // Dispose controller saat widget dihapus
    _amountController.dispose(); // Dispose controller saat widget dihapus
    super.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    _categoryController.text = widget.category ?? '';
    _amountController.text = widget.amount?.toString() ?? '';
    
    // Set default untuk isExpense
    isExpense = widget.isExpense ?? true; // Gunakan nilai dari widget atau default ke true
    
    // Hapus pengaturan default untuk _dateController
    if (widget.date != null) {
      _dateController.text =
          '${widget.date!.day}/${widget.date!.month}/${widget.date!.year}';
    }
    _selectedDate = widget.date; // Set tanggal yang dipilih dari widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Transaction",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form( // Bungkus dengan Form
            key: _formKey, // Tetapkan _formKey di sini
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20), // Jarak vertikal di bawah AppBar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Switch(
                        value: isExpense,
                        onChanged: (bool value) {
                          setState(() {
                            isExpense = value;
                          });
                        },
                        inactiveTrackColor: Colors.green,
                        inactiveThumbColor: Colors.green[200],  
                        activeColor: Colors.red[200],
                        activeTrackColor: Colors.red,

                      ),
                      Text(
                        isExpense ? 'Expense' : 'Income',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30), // Jarak antara switch dan elemen berikutnya
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _amountController, // Controller untuk jumlah
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white), // Warna teks input
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      labelStyle: TextStyle(color: Colors.white), // Warna label
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)), // Border radius saat tidak fokus
                        borderSide: BorderSide(color: Colors.white), // Warna border saat tidak fokus
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)), // Border radius saat fokus
                        borderSide: BorderSide(color: Colors.white), // Warna border saat fokus
                      ),
                    ),
                    validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Amount';
                    }
                    return null;
                    },
                  ),
                ),
                const SizedBox(height: 20), // Jarak antara Amount dan Kategori
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _categoryController, // Controller untuk kategori
                    style: const TextStyle(color: Colors.white), // Warna teks input
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      labelStyle: TextStyle(color: Colors.white), // Warna label
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)), // Border radius saat tidak fokus
                        borderSide: BorderSide(color: Colors.white), // Warna border saat tidak fokus
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)), // Border radius saat fokus
                        borderSide: BorderSide(color: Colors.white), // Warna border saat fokus
                      ),
                    ),
                    validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Category';
                    }
                    return null;
                  },
                  ),
                ),
                const SizedBox(height: 20), // Jarak antara Kategori dan DatePicker
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _dateController, // Controller untuk tanggal
                    readOnly: true, // Membuat field hanya bisa dibaca
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != _selectedDate) {
                        setState(() {
                          _selectedDate = pickedDate;
                          _dateController.text =
                              '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'; // Format tanggal
                        });
                      }
                    },
                    style: const TextStyle(color: Colors.white), // Warna teks input
                    decoration: InputDecoration(
                      labelText: 'Enter Date',
                      labelStyle: const TextStyle(color: Colors.white), // Warna label
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)), // Border radius saat tidak fokus
                        borderSide: BorderSide(color: Colors.white), // Warna border saat tidak fokus
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)), // Border radius saat fokus
                        borderSide: BorderSide(color: Colors.white), // Warna border saat fokus
                      ),
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 18, // Ukuran ikon lebih kecil
                      ),
                    ),
                    validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a Date';
                    }
                    return null;
                  },
                  ),
                ),
                const SizedBox(height: 50), // Tambahkan jarak antara DatePicker dan tombol Save
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16), // Tambahkan padding di sekitar tombol
                    child: SizedBox(
                      width: 200, // Atur lebar tombol agar tidak terlalu lebar
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final category = _categoryController.text;
                            final amount = double.tryParse(_amountController.text) ?? 0.00;
                            final date = _selectedDate ?? DateTime.now(); // Gunakan tanggal yang dipilih atau tanggal saat ini

                            // Kembalikan data ke halaman sebelumnya
                            Navigator.pop(context, {
                              'category': category,
                              'amount': amount,
                              'date': date,
                              'isExpense': isExpense, // Pastikan isExpense selalu dikembalikan
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 194, 166, 249), // Warna tombol
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // Border radius tombol
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding dalam tombol
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}