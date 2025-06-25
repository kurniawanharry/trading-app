import 'package:flutter/material.dart';

class PortofolioScreen extends StatelessWidget {
  const PortofolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          const Text(
            'Portofolio',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Example item count
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Project ${index + 1}'),
                  subtitle: Text('Description of project ${index + 1}'),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
