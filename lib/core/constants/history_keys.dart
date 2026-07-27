import 'package:flutter/material.dart';

class HistoryKeys {
  const HistoryKeys();

  final historyNavTab = const Key('historyNavTab');
  final monthDetailTitle = const Key('monthDetailTitle');
  final monthDetailBackButton = const Key('monthDetailBackButton');
  final monthDetailExpenseList = const Key('monthDetailExpenseList');

  Key historyRow(String monthId) => Key('historyRow_$monthId');
  Key historyEmptyRow(String monthLabel) => Key('historyEmptyRow_$monthLabel');
  Key expenseItem(String expenseId) => Key('expenseItem_$expenseId');
}
