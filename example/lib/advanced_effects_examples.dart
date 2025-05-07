import 'package:flutter/material.dart';
import 'package:flutterwind_core/flutterwind.dart';

class AdvancedEffectsExamples extends StatelessWidget {
  const AdvancedEffectsExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Effects Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExample(
            'Blur Effects',
            Column(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.blue,
                ).className('blur-sm'),
                const SizedBox(height: 8),
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.red,
                ).className('blur-md'),
                const SizedBox(height: 8),
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.green,
                ).className('blur-lg'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Brightness Effects',
            Column(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.blue,
                ).className('brightness-50'),
                const SizedBox(height: 8),
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.red,
                ).className('brightness-75'),
                const SizedBox(height: 8),
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.green,
                ).className('brightness-125'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Contrast Effects',
            Column(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.blue,
                ).className('contrast-50'),
                const SizedBox(height: 8),
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.red,
                ).className('contrast-75'),
                const SizedBox(height: 8),
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.green,
                ).className('contrast-125'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Blend Modes',
            Stack(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.blue,
                ),
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.red.withOpacity(0.5),
                ).className('blend-multiply'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Custom Shaders',
            Container(
              width: 200,
              height: 200,
              color: Colors.blue,
            ).className('shader-gradient'),
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
