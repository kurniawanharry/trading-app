import 'package:flutter/material.dart';

class NumpadScreen extends StatelessWidget {
  const NumpadScreen({
    super.key,
    this.onKeyTap,
  });

  final Function(String)? onKeyTap;

  Widget buildButton(String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
          onPressed: () => onKeyTap!(value),
          child: Text(
            value,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<List<String>> keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', 'DEL'],
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys
          .map(
            (row) => Row(
              children: row.map(buildButton).toList(),
            ),
          )
          .toList(),
    );
  }
}
