import 'package:flutter/material.dart';
import 'package:flutterwind_core/flutterwind.dart';

class TypographyExamples extends StatelessWidget {
  const TypographyExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Typography Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExample(
            'Text Effects',
            Column(
              children: [
                Text('Hello World').className(
                    'text-xl font-bold text-red-500 text-center uppercase'),
                Text('Hello World').className('text-shadow-sm'),
                const SizedBox(height: 8),
                Text('Hello World').className('tracking-wide'),
                const SizedBox(height: 8),
                Text('Hello World').className('word-spacing-wide'),
                const SizedBox(height: 8),
                Text('Hello World').className('leading-loose'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Text Overflow',
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: const Text(
                          'Long text that will be truncated, Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.')
                      .className('text-ellipsis'),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 100,
                  child: const Text('Long text that will wrap to next line...')
                      .className('text-wrap'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Text Selection',
            Column(
              children: [
                Text('This text cannot be selected').className('select-none'),
                const SizedBox(height: 8),
                Text('This text can be selected').className('select-text'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Text Direction',
            Column(
              children: [
                Text('مرحبا بالعالم').className('rtl'),
                const SizedBox(height: 8),
                Text('Hello World').className('ltr'),
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
