import 'package:flutter/material.dart';
import 'package:flutterwind_core/flutterwind.dart';

class AccessibilityExamples extends StatelessWidget {
  const AccessibilityExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExample(
            'Input Border Styles',
            Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'No Border',
                  ),
                ).className('input-none'),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Outline Border',
                  ),
                ).className('input-outline'),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Underline Border',
                  ),
                ).className('input-underline'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Input Sizes',
            Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Small Input',
                  ),
                ).className('input-sm'),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Medium Input',
                  ),
                ).className('input-md'),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Large Input',
                  ),
                ).className('input-lg'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Input States',
            Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Focus Ring',
                  ),
                ).className('input-focus:ring'),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Focus Border',
                  ),
                ).className('input-focus:border'),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Hover Border',
                  ),
                ).className('input-hover:border'),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Disabled',
                  ),
                  enabled: false,
                ).className('input-disabled:opacity'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExample(String title, Widget example) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        example,
      ],
    );
  }
}
