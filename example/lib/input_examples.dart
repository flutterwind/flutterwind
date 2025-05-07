import 'package:flutter/material.dart';
import 'package:flutterwind_core/flutterwind.dart';

class InputExamples extends StatelessWidget {
  const InputExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Input
            const Text('Basic Input',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Basic Input',
              ),
            ).className(
                'bg-gray-700 border border-gray-300 text-gray-900 text-sm rounded-lg p-2.5'),
            const SizedBox(height: 24),

            // Border Styles
            const Text('Border Styles',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Outline Border
            TextField(
              decoration: const InputDecoration(
                labelText: 'Outline Border',
              ),
            ).className('border-2 border-gray-300 rounded-lg p-2.5'),
            const SizedBox(height: 8),
            // Underline Border
            TextField(
              decoration: const InputDecoration(
                labelText: 'Underline Border',
              ),
            ).className('border-b-2 border-gray-300 p-2.5'),
            const SizedBox(height: 8),
            // No Border
            TextField(
              decoration: const InputDecoration(
                labelText: 'No Border',
              ),
            ).className('border-0 bg-gray-50 rounded-lg p-2.5'),
            const SizedBox(height: 24),

            // Input Sizes
            const Text('Input Sizes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Small
            TextField(
              decoration: const InputDecoration(
                labelText: 'Small Input',
              ),
            ).className('input-xs border border-gray-300 rounded-lg'),
            const SizedBox(height: 8),
            // Medium
            TextField(
              decoration: const InputDecoration(
                labelText: 'Medium Input',
              ),
            ).className('input-md border border-gray-300 rounded-lg'),
            const SizedBox(height: 8),
            // Large
            TextField(
              decoration: const InputDecoration(
                labelText: 'Large Input',
              ),
            ).className('input-lg border border-gray-300 rounded-lg'),
            const SizedBox(height: 24),

            // Input States
            const Text('Input States',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Focus State
            TextField(
              decoration: const InputDecoration(
                labelText: 'Focus State',
              ),
            ).className(
                'border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 p-2.5'),
            const SizedBox(height: 8),
            // Hover State
            TextField(
              decoration: const InputDecoration(
                labelText: 'Hover State',
              ),
            ).className(
                'border border-gray-300 rounded-lg hover:border-blue-500 p-2.5'),
            const SizedBox(height: 8),
            // Disabled State
            TextField(
              decoration: const InputDecoration(
                labelText: 'Disabled State',
              ),
              enabled: false,
            ).className(
                'bg-gray-100 border border-gray-300 rounded-lg p-2.5 text-gray-500'),
            const SizedBox(height: 24),

            // Custom Styling
            const Text('Custom Styling',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Custom Padding
            TextField(
              decoration: const InputDecoration(
                labelText: 'Custom Padding',
              ),
            ).className('border border-gray-300 rounded-lg p-4'),
            const SizedBox(height: 8),
            // Custom Font Size
            TextField(
              decoration: const InputDecoration(
                labelText: 'Custom Font Size',
              ),
            ).className('border border-gray-300 rounded-lg p-2.5 text-lg'),
            const SizedBox(height: 8),
            // Custom Colors
            TextField(
              decoration: const InputDecoration(
                labelText: 'Custom Colors',
              ),
            ).className(
                'bg-blue-50 border border-blue-300 text-blue-900 rounded-lg p-2.5 focus:ring-blue-500 focus:border-blue-500'),
            const SizedBox(height: 24),

            // TextFormField Examples
            const Text('TextFormField Examples',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // With Validation
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ).className(
                'border border-gray-300 rounded-lg p-2.5 focus:ring-blue-500 focus:border-blue-500'),
            const SizedBox(height: 8),
            // Password Field
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ).className(
                'border border-gray-300 rounded-lg p-2.5 focus:ring-blue-500 focus:border-blue-500'),
            const SizedBox(height: 8),
            // Dark Mode
            TextField(
              decoration: const InputDecoration(
                labelText: 'Dark Mode Input',
              ),
            ).className(
                'bg-gray-700 border border-gray-600 text-white rounded-lg p-2.5 dark:focus:ring-blue-500 dark:focus:border-blue-500'),
          ],
        ),
      ),
    );
  }
}
