import 'package:flutter/material.dart';
import './chart_bar.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDays = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDays.day &&
            recentTransactions[i].date.month == weekDays.month &&
            recentTransactions[i].date.year == weekDays.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      print(
        DateFormat.E().format(weekDays),
      );
      print(totalSum);
      return {
        'day': DateFormat.E().format(weekDays).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalspending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  data['day'],
                  data['amount'],
                  totalspending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalspending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
