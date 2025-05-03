import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({
    super.key,
    this.category,
    this.amount,
    this.date,
    this.isExpense,
  });

  final String? category;
  final String? amount;
  final DateTime? date;
  final bool? isExpense;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  bool _isExpense = true; // Hindari konflik nama
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _categoryController.text = widget.category ?? '';
    _amountController.text = widget.amount ?? '';
    _isExpense = widget.isExpense ?? true;

    if (widget.date != null) {
      _selectedDate = widget.date;
      _dateController.text = '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
    }
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Switch(
                        value: _isExpense,
                        onChanged: (bool value) {
                          setState(() {
                            _isExpense = value;
                          });
                        },
                        inactiveTrackColor: Colors.green,
                        inactiveThumbColor: Colors.green[200],
                        activeColor: Colors.red[200],
                        activeTrackColor: Colors.red,
                      ),
                      Text(
                        _isExpense ? 'Expense' : 'Income',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter Amount';
                      }
                      final amount = double.tryParse(value.trim());
                      if (amount == null || amount <= 0) {
                        return 'Enter a valid positive amount';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _categoryController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.white),
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
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                          _dateController.text =
                              '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                        });
                      }
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Enter Date',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 18,
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
                const SizedBox(height: 50),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final category = _categoryController.text.trim();
                            final amount = double.tryParse(_amountController.text.trim()) ?? 0.00;
                            final date = _selectedDate ?? DateTime.now();

                            Navigator.pop(context, {
                              'category': category,
                              'amount': amount,
                              'date': date,
                              'isExpense': _isExpense,
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 194, 166, 249),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
