import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BasicCalculatorPage(),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
    );
  }
}

class BasicCalculatorPage extends StatefulWidget {
  @override
  _BasicCalculatorPageState createState() => _BasicCalculatorPageState();
}

class _BasicCalculatorPageState extends State<BasicCalculatorPage> {
  String displayString = "0";
  String? firstOperand;
  String? operator;
  String currentNumber = "";

  void buttonTapped(String value) {
    setState(() {
      if (value == "C") {
        displayString = "0";
        firstOperand = null;
        operator = null;
        currentNumber = "";
      } else if (["+", "-", "*", "/"].contains(value)) {
        if (currentNumber.isNotEmpty) {
          firstOperand = currentNumber;
          operator = value;
          currentNumber = "";
          displayString = "$firstOperand $operator";
        }
      } else if (value == "=") {
        if (firstOperand != null && operator != null && currentNumber.isNotEmpty) {
          double num1 = double.parse(firstOperand!);
          double num2 = double.parse(currentNumber);
          double result = 0;

          if (operator == "+") result = num1 + num2;
          if (operator == "-") result = num1 - num2;
          if (operator == "*") result = num1 * num2;
          if (operator == "/") {
            if (num2 == 0) {
              displayString = "Error";
              firstOperand = null;
              operator = null;
              currentNumber = "";
              return;
            }
            result = num1 / num2;
          }

          displayString = result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 2);
          firstOperand = null;
          operator = null;
          currentNumber = "";
        }
      } else {
        if (displayString == "Error") {
          displayString = "0";
          currentNumber = "";
        }

        if (value == "." && currentNumber.contains(".")) return;
        if (currentNumber.isEmpty && value == ".") currentNumber = "0";

        if (currentNumber == "0" && value != ".") {
          currentNumber = value;
        } else if (currentNumber.length < 9) {
          currentNumber += value;
        }

        displayString = currentNumber;
      }
    });
  }

  Widget calcButton(String label, {Color? color}) {
    return ElevatedButton(
      onPressed: () => buttonTapped(label),
      child: Text(
        label,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.grey[850],
        foregroundColor: Colors.white,
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        elevation: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> buttons = [
      "C", "", "", "/",
      "7", "8", "9", "*",
      "4", "5", "6", "-",
      "1", "2", "3", "+",
      "0", ".", "=", ""
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Calculator"),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Text(
                displayString,
                style: TextStyle(fontSize: 52, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Divider(color: Colors.grey[800]),
          Container(
            padding: EdgeInsets.all(8),
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: buttons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                String label = buttons[index];
                if (label == "") return SizedBox.shrink();

                Color? btnColor;
                if (["/", "*", "-", "+"].contains(label)) {
                  btnColor = Colors.orange[400];
                } else if (label == "=") {
                  btnColor = Colors.lightBlue;
                } else if (label == "C") {
                  btnColor = Colors.redAccent;
                }

                return calcButton(label, color: btnColor);
              },
            ),
          ),
        ],
      ),
    );
  }
}
