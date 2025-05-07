import 'package:flutter/material.dart';
import 'package:flutterwind_core/flutterwind.dart';

class AnimationExamples extends StatelessWidget {
  const AnimationExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExample(
            'Fade Animation',
            Container(
              width: 100,
              height: 100,
              color: Colors.blue,
            ).className('animate-fade animate-normal ease-in-out'),
          ),
          _buildExample(
            'Pulse Animation',
            Container(
              width: 100,
              height: 100,
              color: Colors.blue,
            ).className('animate-pulse animate-normal ease-in-out'),
          ),
          _buildExample(
            'Bounce Animation',
            Container(
              width: 100,
              height: 100,
              color: Colors.blue,
            ).className('animate-bounce animate-normal ease-in-out'),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Scale Animation',
            Container(
              width: 100,
              height: 100,
              color: Colors.red,
            ).className('animate-scale animate-slow'),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Ping Animation',
            Container(
              width: 100,
              height: 100,
              color: Colors.red,
            ).className('animate-ping animate-slow'),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Fade Animation',
            Container(
              width: 100,
              height: 100,
              color: Colors.red,
            ).className('animate-fade animate-slow'),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Slide Animation',
            Container(
              width: 100,
              height: 100,
              color: Colors.green,
            ).className('animate-slide animate-slow'),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Rotate Animation',
            Container(
              width: 100,
              height: 100,
              color: Colors.purple,
            ).className('animate-rotate animate-normal'),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Combined Animation',
            Container(
              width: 100,
              height: 100,
              color: Colors.orange,
            ).className('animate-fade animate-normal'),
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
