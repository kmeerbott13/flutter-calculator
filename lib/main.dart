import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart'; // External package for expression evaluation

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _expression = '';
  String _result = '';
  bool _hasError = false;

  void _addToExpression(String value) {
    setState(() {
      if (_hasError) {
        _expression = '';
        _result = '';
        _hasError = false;
      }
      _expression += value;
    });
  }

  void _clear() {
    setState(() {
      _expression = '';
      _result = '';
      _hasError = false;
    });
  }

  void _calculate() {
    try {
      // Replace × with * and ÷ with / for the expression parser
      String sanitizedExpression =
          _expression.replaceAll('×', '*').replaceAll('÷', '/');

      // Create expression parser
      final expression = Expression.parse(sanitizedExpression);
      final evaluator = const ExpressionEvaluator();

      // Evaluate and handle potential division by zero
      final result = evaluator.eval(expression, {});

      if (result.isInfinite || result.isNaN) {
        throw Exception('Invalid calculation');
      }

      setState(() {
        _result = ' = ${result.toString()}';
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _result = ' Error';
        _hasError = true;
      });
    }
  }

  Widget _buildButton(String text, {Color? color, VoidCallback? onPressed}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[300],
            padding: const EdgeInsets.all(20),
          ),
          onPressed: onPressed ?? () => _addToExpression(text),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              color: color != null ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Kai Meerbott", // Replace with your name
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Display
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _expression,
                  style: const TextStyle(fontSize: 24),
                ),
                Text(
                  _result,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: _hasError ? Colors.red : Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const Divider(thickness: 2),

          // Calculator Buttons
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // First row
                  Row(
                    children: [
                      _buildButton(
                        'C',
                        color: Colors.red,
                        onPressed: _clear,
                      ),
                      _buildButton('('),
                      _buildButton(')'),
                      _buildButton('÷', color: Colors.blue),
                    ],
                  ),
                  // Second row
                  Row(
                    children: [
                      _buildButton('7'),
                      _buildButton('8'),
                      _buildButton('9'),
                      _buildButton('×', color: Colors.blue),
                    ],
                  ),
                  // Third row
                  Row(
                    children: [
                      _buildButton('4'),
                      _buildButton('5'),
                      _buildButton('6'),
                      _buildButton('-', color: Colors.blue),
                    ],
                  ),
                  // Fourth row
                  Row(
                    children: [
                      _buildButton('1'),
                      _buildButton('2'),
                      _buildButton('3'),
                      _buildButton('+', color: Colors.blue),
                    ],
                  ),
                  // Fifth row
                  Row(
                    children: [
                      _buildButton('0'),
                      _buildButton('.'),
                      _buildButton(
                        '=',
                        color: Colors.green,
                        onPressed: _calculate,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
