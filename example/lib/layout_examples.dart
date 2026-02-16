import 'package:flutter/material.dart';
import 'package:flutterwind_core/flutterwind.dart';
import 'components/button.dart';

class LayoutExamples extends StatelessWidget {
  const LayoutExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Layout Examples')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FlutterwindButton(
            onPressed: () {},
            variant: 'destructive',
            child: Text('Button'),
          ),
          _buildExample(
            'Grid Layout',
            Container(
              child: [
                Container(height: 50, color: Colors.blue),
                Container(height: 50, color: Colors.red),
                Container(height: 50, color: Colors.green),
              ].className('grid grid-cols-3 gap-4'),
            ).className('w-full'),
          ),
          _buildExample(
            'Grid Layout with colspan',
            Container(
              child: [
                Container(height: 50, color: Colors.blue).colSpan(2),
                Container(height: 50, color: Colors.red),
                Container(height: 50, color: Colors.green),
              ].className('grid grid-cols-4 gap-4'),
            ).className('w-full'),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Flex Layout',
            Container(
              child: [
                Text("Flex Row").className('text-sm font-bold underline'),
                Container(
                  child: [
                    Container(width: 50, height: 50, color: Colors.blue),
                    Container(width: 50, height: 50, color: Colors.red),
                  ].className('flex flex-row'),
                ).className('w-full'),
                Text("Flex Column").className('text-sm font-bold underline'),
                Container(
                  child: [
                    Container(width: 50, height: 50, color: Colors.blue),
                    Container(width: 50, height: 50, color: Colors.red),
                  ].className('flex flex-col'),
                ).className('w-full'),
                Text(
                  "Justify Between",
                ).className('text-sm font-bold underline'),
                Container(
                  child: [
                    Container(width: 50, height: 50, color: Colors.blue),
                    Container(width: 50, height: 50, color: Colors.red),
                  ].className('flex flex-row justify-between'),
                ).className('w-full'),
                Text("Justify Around").className('text-sm font-bold underline'),
                Container(
                  child: [
                    Container(width: 50, height: 50, color: Colors.blue),
                    Container(width: 50, height: 50, color: Colors.red),
                  ].className('flex flex-row justify-around'),
                ).className('w-full'),
                Text("Justify center").className('text-sm font-bold underline'),
                Container(
                  child: [
                    Container(width: 50, height: 50, color: Colors.blue),
                    Container(width: 50, height: 50, color: Colors.red),
                  ].className('flex flex-row justify-center'),
                ).className('w-full'),
              ].className('flex flex-col gap-4'),
            ),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Spacing',
            Container(
              child: [
                Text("Space X").className('text-sm font-bold underline'),
                Container(
                  child: [
                    Container(width: 50, height: 50, color: Colors.blue),
                    Container(width: 50, height: 50, color: Colors.red),
                  ].className('flex flex-row space-x-4'),
                ).className('w-full'),
                Text("Space Y").className('text-sm font-bold underline'),
                Container(
                  child: [
                    Container(width: 50, height: 50, color: Colors.blue),
                    Container(width: 50, height: 50, color: Colors.red),
                  ].className('flex flex-col space-y-4'),
                ).className('w-full'),
              ].className('flex flex-col gap-4'),
            ).className('w-full'),
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Flex Properties',
            Column(
              children: [
                // Grow
                Container(
                  child: [
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.blue,
                    ).className('grow-1'),
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.red,
                    ).className('grow-2'),
                  ].className('flex flex-row'),
                ).className('w-full'),
                const SizedBox(height: 16),
                // Shrink
                Container(
                  child: [
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.blue,
                    ).className('shrink-1'),
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.red,
                    ).className('shrink-0'),
                  ].className('flex flex-row'),
                ).className('w-full'),
                const SizedBox(height: 16),
                // Basis
                Container(
                  child: [
                    Container(
                      height: 50,
                      color: Colors.blue,
                    ).className('basis-32'),
                    Container(
                      height: 50,
                      color: Colors.red,
                    ).className('basis-64'),
                  ].className('flex flex-row'),
                ).className('w-full'),
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
        Text(title).className('font-bold text-xl'),
        const SizedBox(height: 8),
        example,
      ],
    );
  }
}
