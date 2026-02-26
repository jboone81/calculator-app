import 'package:flutter/material.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String display = '';
  double? firstNumber;
  String? operator;
  bool waitingForSecond = false;

  bool isDarkTheme = false;

  void _numberPressed(String value) {
    setState(() {
      if (waitingForSecond) {
        display = value;
        waitingForSecond = false;
      } else if (display.length < 11) {
        display += value;
      }
    });
  }

  void _operatorPressed(String op) {
    setState(() {
      if (display.isNotEmpty) {
        firstNumber = double.parse(display);
        operator = op;
        waitingForSecond = true;
      }
    });
  }

  void _calculateResult() {
    if (firstNumber != null && operator != null && display.isNotEmpty) {
      double secondNumber = double.parse(display);
      double result = 0;
      switch (operator) {
        case '+':
          result = firstNumber! + secondNumber;
          break;
        case '−':
          result = firstNumber! - secondNumber;
          break;
        case '×':
          result = firstNumber! * secondNumber;
          break;
        case '÷':
          result = firstNumber! / secondNumber;
          break;
      }
      setState(() {
        display =
            result % 1 == 0 ? result.toInt().toString() : result.toString();
        firstNumber = null;
        operator = null;
      });
    }
  }

  void _clearDisplay() {
    setState(() {
      display = '';
      firstNumber = null;
      operator = null;
      waitingForSecond = false;
    });
  }

  Widget buildButton(String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          onPressed: () {
            if ('0123456789'.contains(label)) {
              _numberPressed(label);
            } else if (label == '=') {
              _calculateResult();
            } else if (label == 'Clear') {
              _clearDisplay();
            } else {
              _operatorPressed(label);
            }
          },
          child: Text(label, style: TextStyle(fontSize: 18)),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 20)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData lightTheme = ThemeData.light();
    ThemeData darkTheme = ThemeData.dark();

    return MaterialApp(
      theme: isDarkTheme ? darkTheme : lightTheme,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Theme toggle switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Light'),
                    Switch(
                      value: isDarkTheme,
                      onChanged: (val) {
                        setState(() {
                          isDarkTheme = val;
                        });
                      },
                    ),
                    Text('Dark'),
                  ],
                ),
                SizedBox(height: 8),
                // Display box
                Container(
                  width: 250,
                  height: 50,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  color: Colors.grey[300],
                  child: Text(
                    display,
                    style: TextStyle(fontSize: 24, color: Colors.red),
                  ),
                ),
                SizedBox(height: 8),
                // Buttons
                Column(
                  children: [
                    Row(children: [
                      buildButton('1'),
                      buildButton('2'),
                      buildButton('3'),
                      buildButton('+'),
                    ]),
                    Row(children: [
                      buildButton('4'),
                      buildButton('5'),
                      buildButton('6'),
                      buildButton('−'),
                    ]),
                    Row(children: [
                      buildButton('7'),
                      buildButton('8'),
                      buildButton('9'),
                      buildButton('×'),
                    ]),
                    Row(children: [
                      buildButton('0'),
                      buildButton('=',),
                      buildButton('Clear'),
                      buildButton('÷'),
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}