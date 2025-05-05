import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CategoryPieChart extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;
  final bool showExpenses; // true for expenses, false for income

  const CategoryPieChart({
    super.key,
    required this.transactions,
    this.showExpenses = true,
  });

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final categoryData = _processCategoryData();
    
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: const Color.fromARGB(255, 55, 57, 74),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.showExpenses ? 'Expense by Category' : 'Income by Category',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: categoryData.isEmpty
                  ? const Center(
                      child: Text(
                        'No data available',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: _showingSections(categoryData),
                      ),
                    ),
            ),
            if (categoryData.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: _buildIndicators(categoryData),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _processCategoryData() {
    final Map<String, double> categoryMap = {};
    
    // Filter transactions by expense/income type
    final filteredTransactions = widget.transactions.where(
      (tx) => tx['isExpense'] == widget.showExpenses
    ).toList();
    
    // Group by category and sum amounts
    for (var tx in filteredTransactions) {
      final category = tx['category'] as String;
      final amount = tx['amount'] as double;
      
      categoryMap[category] = (categoryMap[category] ?? 0) + amount;
    }
    
    // Convert map to list and sort by amount (descending)
    final result = categoryMap.entries
        .map((e) => {'category': e.key, 'amount': e.value})
        .toList();
    
    result.sort((a, b) => (b['amount'] as double).compareTo(a['amount'] as double));
    
    // Take top 5 categories and group the rest as "Others"
    if (result.length > 5) {
      double othersAmount = 0;
      for (int i = 5; i < result.length; i++) {
        othersAmount += result[i]['amount'] as double;
      }
      
      final topFive = result.sublist(0, 5);
      if (othersAmount > 0) {
        topFive.add({'category': 'Others', 'amount': othersAmount});
      }
      
      return topFive;
    }
    
    return result;
  }

  // Define pie chart sections
  List<PieChartSectionData> _showingSections(List<Map<String, dynamic>> categoryData) {
    // Calculate total for percentages
    final total = categoryData.fold<double>(
      0, (sum, item) => sum + (item['amount'] as double)
    );
    
    // Define a list of colors for pie sections
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.amber,
    ];

    return List.generate(categoryData.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      
      final amount = categoryData[i]['amount'] as double;
      final percentage = (amount / total * 100).toStringAsFixed(1);
      
      return PieChartSectionData(
        color: colors[i % colors.length],
        value: amount,
        title: '$percentage%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  // Build category indicators for legend
  List<Widget> _buildIndicators(List<Map<String, dynamic>> categoryData) {
    // Define a list of colors for indicators
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.amber,
    ];
    
    return List.generate(categoryData.length, (index) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors[index % colors.length],
            ),
          ),
          const SizedBox(width: 4),
          Text(
            categoryData[index]['category'] as String,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      );
    });
  }
}