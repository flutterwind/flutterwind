import 'package:flutter/material.dart';
import 'package:flutterwind_core/flutterwind.dart';

class TransitionExamples extends StatelessWidget {
  const TransitionExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transition Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExample(
            'Fade Transition',
            Container(
              width: 100,
              height: 100,
              color: Colors.blue,
            ).className('transition-fade transition-normal'),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Scale Transition',
            Container(
              width: 100,
              height: 100,
              color: Colors.red,
            ).className('transition-scale transition-fast'),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Slide Transition',
            Container(
              width: 100,
              height: 100,
              color: Colors.green,
            ).className('transition-slide transition-slow'),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Rotate Transition',
            Container(
              width: 100,
              height: 100,
              color: Colors.purple,
            ).className('transition-rotate transition-normal'),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Combined Transition',
            Container(
              width: 100,
              height: 100,
              color: Colors.orange,
            ).className('transition-combined transition-normal'),
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
