import 'dart:math';
import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:flutter/material.dart';
import 'components/transaction_form.dart';
import 'components/transaction_list.dart';
import 'models/transaction.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
              button: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = true;

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  List<Transaction> get _recentTransactions {
    return _transactions
        .where(
            (tr) => tr.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool _isLandScape = mediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text(
        'Despesas Pessoais',
        style: TextStyle(fontSize: 20 * mediaQuery.textScaleFactor),
      ),
      actions: <Widget>[
        if (_isLandScape)
          IconButton(
            icon: Icon(_showChart ? Icons.list : Icons.bar_chart_rounded),
            onPressed: () {
              setState(() {
                _showChart = !_showChart;
              });
            },
          ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _openTransactionFormModal(context),
        ),
      ],
    );

    final availableHeigh = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // if (_isLandScape)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text('Exibir Gráfico'),
            //       Switch(
            //         value: _showChart,
            //         onChanged: (value) {
            //           setState(() {
            //             _showChart = value;
            //           });
            //         },
            //       ),
            //     ],
            //   ),
            if (!_isLandScape || _showChart)
              Container(
                height: availableHeigh * (_isLandScape ? 0.50 : 0.30),
                child: Chart(_recentTransactions),
              ),
            Container(
              height: availableHeigh *
                  (_isLandScape && _showChart
                      ? 0.50
                      : _isLandScape
                          ? 1
                          : 0.70),
              child: TransactionList(_transactions, _removeTransaction),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

final List<Transaction> _transactions = [
  Transaction(
    id: 't0',
    title: 'Conta Antiga',
    value: 310.76,
    date: DateTime.now().subtract(Duration(days: 33)),
  ),
  Transaction(
    id: 't1',
    title: 'Mouse',
    value: 60.00,
    date: DateTime.now().subtract(Duration(days: 6)),
  ),
  Transaction(
    id: 't2',
    title: 'Conta de Luz',
    value: 211.30,
    date: DateTime.now().subtract(Duration(days: 3)),
  ),
  Transaction(
    id: 't3',
    title: 'Net',
    value: 186.0,
    date: DateTime.now().subtract(Duration(days: 2)),
  ),
  Transaction(
    id: 't4',
    title: 'Conta de agua',
    value: 72.60,
    date: DateTime.now(),
  ),
  Transaction(
    id: 't5',
    title: 'Netflix',
    value: 46.80,
    date: DateTime.now().subtract(Duration(days: 1)),
  ),
  Transaction(
    id: 't6',
    title: 'Cartão de Crédito',
    value: 1546.80,
    date: DateTime.now().subtract(Duration(days: 4)),
  ),
];
