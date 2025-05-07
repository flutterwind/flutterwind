import 'package:flutter/material.dart';
import 'package:flutterwind_core/flutterwind.dart';

class PerformanceExamples extends StatelessWidget {
  const PerformanceExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExample(
            'Lazy Loading',
            Column(
              children: [
                Image.network(
                  'https://picsum.photos/200',
                  width: 200,
                  height: 200,
                ).className('lazy-load'),
                // .className('lazy-load'),
                const SizedBox(height: 8),
                Text('Image will load when visible'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'List Optimization',
            SizedBox(
              height: 1000, // Fixed height for the list
              child: ListView.builder(
                itemCount: 200000,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      'Item $index',
                      style: const TextStyle(
                        fontSize: 14, // Smaller font size
                      ),
                    ),
                  ).className('widget-recycle memory-optimize');
                },
              ),
            ),
          ),
          // const SizedBox(height: 16),
          // _buildExample(
          //   'Image Optimization',
          //   Column(
          //     children: [
          //       Image.network(
          //         'https://picsum.photos/200',
          //         width: 200,
          //         height: 200,
          //       ).className('image-optimize quality-priority'),
          //       const SizedBox(height: 8),
          //       Image.network(
          //         'https://picsum.photos/200',
          //         width: 200,
          //         height: 200,
          //       ).className('image-optimize size-priority'),
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 16),
          // _buildExample(
          //   'Event Debouncing',
          //   TextField(
          //     decoration: const InputDecoration(
          //       labelText: 'Debounced Search',
          //     ),
          //     onChanged: (value) {
          //       // Search logic here
          //     },
          //   ).className('debounce-300'),
          // ),
          // const SizedBox(height: 16),
          // _buildExample(
          //   'Event Throttling',
          //   TextField(
          //     decoration: const InputDecoration(
          //       labelText: 'Throttled Input',
          //     ),
          //     onChanged: (value) {
          //       // Input logic here
          //     },
          //   ).className('throttle-500'),
          // ),
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
