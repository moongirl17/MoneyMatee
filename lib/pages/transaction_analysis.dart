import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TransactionAnalysisChart extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;

  const TransactionAnalysisChart({
    super.key,
    required this.transactions,
  });

  @override
  State<TransactionAnalysisChart> createState() => _TransactionAnalysisChartState();
}

class _TransactionAnalysisChartState extends State<TransactionAnalysisChart> {
  bool showAverage = false;
  
  // Colors for the chart
  List<Color> incomeGradientColors = [
    const Color.fromARGB(255, 76, 175, 80).withOpacity(0.7),
    const Color.fromARGB(255, 76, 175, 80).withOpacity(0.3),
  ];
  
  List<Color> expenseGradientColors = [
    const Color.fromARGB(255, 244, 67, 54).withOpacity(0.7),
    const Color.fromARGB(255, 244, 67, 54).withOpacity(0.3),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              showAverage ? avgData() : mainData(),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAverage = !showAverage;
              });
            },
            child: Text(
              'Average',
              style: TextStyle(
                fontSize: 12,
                color: showAverage
                    ? Theme.of(context).primaryColor
                    : Colors.white.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
    color: Colors.white70,
  );

  final today = DateTime.now();
  final date = today.subtract(Duration(days: (30 - value.toInt())));

  Widget text;
  if (value.toInt() % 5 == 0) {
    text = Text('${date.day}/${date.month}', style: style);
  } else {
    text = const Text('', style: style);
  }

  return SideTitleWidget(
    meta: meta,
    child: text,
  );
}



  // Widget to display the left titles (amounts)
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Colors.white70,
    );
    
    String text;
    if (value % 100 == 0 && value > 0) {
      text = '${value.toInt()}k';
    } else {
      return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  // Process transaction data to get spots for the chart
  List<FlSpot> getIncomeSpots() {
    Map<int, double> dailyIncome = {};
    
    // Initialize map for the last 30 days
    final today = DateTime.now();
    for (int i = 0; i < 30; i++) {
      dailyIncome[i] = 0;
    }
    
    // Fill in data from transactions
    for (var tx in widget.transactions) {
      if (tx['isExpense'] == false) {
        final txDate = tx['date'] as DateTime;
        final difference = today.difference(txDate).inDays;
        
        // Only consider transactions from the last 30 days
        if (difference >= 0 && difference < 30) {
          dailyIncome[29 - difference] = (dailyIncome[29 - difference] ?? 0) + tx['amount'];
        }
      }
    }
    
    // Convert to FlSpots
    return dailyIncome.entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value / 1000)) // Convert to K
        .toList();
  }
  
  List<FlSpot> getExpenseSpots() {
    Map<int, double> dailyExpense = {};
    
    // Initialize map for the last 30 days
    final today = DateTime.now();
    for (int i = 0; i < 30; i++) {
      dailyExpense[i] = 0;
    }
    
    // Fill in data from transactions
    for (var tx in widget.transactions) {
      if (tx['isExpense'] == true) {
        final txDate = tx['date'] as DateTime;
        final difference = today.difference(txDate).inDays;
        
        // Only consider transactions from the last 30 days
        if (difference >= 0 && difference < 30) {
          dailyExpense[29 - difference] = (dailyExpense[29 - difference] ?? 0) + tx['amount'];
        }
      }
    }
    
    // Convert to FlSpots
    return dailyExpense.entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value / 1000)) // Convert to K
        .toList();
  }

  // Calculate average daily income
  double getAverageIncome() {
    if (widget.transactions.isEmpty) return 0;
    
    double totalIncome = 0;
    int count = 0;
    
    for (var tx in widget.transactions) {
      if (tx['isExpense'] == false) {
        totalIncome += tx['amount'];
        count++;
      }
    }
    
    return count > 0 ? (totalIncome / count) / 1000 : 0; // Convert to K
  }
  
  // Calculate average daily expense
  double getAverageExpense() {
    if (widget.transactions.isEmpty) return 0;
    
    double totalExpense = 0;
    int count = 0;
    
    for (var tx in widget.transactions) {
      if (tx['isExpense'] == true) {
        totalExpense += tx['amount'];
        count++;
      }
    }
    
    return count > 0 ? (totalExpense / count) / 1000 : 0; // Convert to K
  }

  // Main data for the chart (actual transactions)
  LineChartData mainData() {
    final incomeSpots = getIncomeSpots();
    final expenseSpots = getExpenseSpots();
    
    // Find the maximum value to set the Y axis range
    double maxY = 0;
    for (var spot in [...incomeSpots, ...expenseSpots]) {
      if (spot.y > maxY) maxY = spot.y;
    }
    
    // Ensure we have a reasonable maxY
    maxY = maxY > 0 ? maxY * 1.2 : 100;
    
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 100,
        verticalInterval: 5,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 100,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.white24),
      ),
      minX: 0,
      maxX: 29,
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        // Income Line
        LineChartBarData(
          spots: incomeSpots,
          isCurved: true,
          gradient: LinearGradient(
            colors: incomeGradientColors,
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: incomeGradientColors.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
        // Expense Line
        LineChartBarData(
          spots: expenseSpots,
          isCurved: true,
          gradient: LinearGradient(
            colors: expenseGradientColors,
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: expenseGradientColors.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // Average data for the chart
  LineChartData avgData() {
    final avgIncome = getAverageIncome();
    final avgExpense = getAverageExpense();
    
    // Find the maximum value to set the Y axis range
    double maxY = avgIncome > avgExpense ? avgIncome : avgExpense;
    maxY = maxY > 0 ? maxY * 1.2 : 100;
    
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 5,
        horizontalInterval: 100,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 100,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.white24),
      ),
      minX: 0,
      maxX: 29,
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        // Average Income Line
        LineChartBarData(
          spots: List.generate(30, (index) => FlSpot(index.toDouble(), avgIncome)),
          isCurved: false,
          gradient: LinearGradient(
            colors: incomeGradientColors,
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        ),
        // Average Expense Line
        LineChartBarData(
          spots: List.generate(30, (index) => FlSpot(index.toDouble(), avgExpense)),
          isCurved: false,
          gradient: LinearGradient(
            colors: expenseGradientColors,
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        ),
      ],
    );
  }
}