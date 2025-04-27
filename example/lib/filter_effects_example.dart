import 'package:flutter/material.dart';
import 'package:flutterwind_core/flutterwind.dart';

class FilterEffectsDemo extends StatelessWidget {
  const FilterEffectsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Effects Demo'),
      ),
      body: [
          Container(
            color: Colors.blue,
          ).className('blur-md w-[100] h-[100]'),
          const Text('blur-md'),

          const SizedBox(height: 20),

          // Brightness effect
          [
            Image.network(
              'https://picsum.photos/200',
              width: 100,
              height: 100,
            ),
            Image.network(
              'https://picsum.photos/200',
              width: 100,
              height: 100,
            ).className('brightness-150'),
          ].className("flex flex-row gap-2"),
          const Text('Normal vs brightness-150'),
          const SizedBox(height: 20),

          // Contrast effect
          [
            Image.network(
              'https://picsum.photos/200',
              width: 100,
              height: 100,
            ),
            Image.network(
              'https://picsum.photos/200',
              width: 100,
              height: 100,
            ).className('contrast-200'),
          ].className("flex flex-row gap-2"),
          const Text('Normal vs contrast-200'),

          const SizedBox(height: 20),

          // Drop shadow effect
          Container(
            width: 200,
            height: 100,
            color: Colors.white,
            child: const Center(
              child: Text('No Shadow'),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 200,
            height: 100,
            color: Colors.white,
            child: const Center(
              child: Text('drop-shadow-lg'),
            ),
          ).className('drop-shadow-lg'),

          const SizedBox(height: 20),

          // Backdrop filter (blur behind an element)
          Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                'https://picsum.photos/400/200',
                width: 300,
              ),
              Container(
                width: 200,
                height: 100,
                color: Colors.white.withOpacity(0.5),
                child: const Center(
                  child: Text('No backdrop filter'),
                ),
              ),
              Positioned(
                bottom: 20,
                child: Container(
                  width: 200,
                  height: 100,
                  color: Colors.white.withOpacity(0.5),
                  child: const Center(
                    child: Text('backdrop-blur-md'),
                  ),
                ).className('backdrop-blur-md'),
              ),
            ],
          ),
          const SizedBox(height: 50),
        ].className(
            "flex flex-col items-center justify-start gap-3 p-4 w-full h-auto overflow-scroll"),
    );
  }
}
