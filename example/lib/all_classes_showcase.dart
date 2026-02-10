import 'package:flutter/material.dart';
import 'package:flutterwind_core/flutterwind.dart';

class AllClassesShowcase extends StatelessWidget {
  const AllClassesShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Classes Showcase')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(
            'Spacing + Colors + Borders + Shadow + Opacity',
            Container(
              child: const Text('Card utility stack'),
            ).className(
              'p-4 m-2 bg-blue-500 rounded-lg shadow-lg opacity-75 text-white',
            ),
          ),
          _section(
            'Sizing + Aspect Ratio + Position',
            [
              Container(
                color: Colors.orange,
                child: const Center(child: Text('w-[10rem] h-[5rem]')),
              ).className('w-[10rem] h-[5rem] rounded-md'),
              Container(
                color: Colors.teal,
                child: const Center(child: Text('aspect-video')),
              ).className('w-[12rem] aspect-video rounded-md'),
            ].className('flex flex-wrap gap-4'),
          ),
          _section(
            'Typography + Text Effects',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Heading example').className(
                  'text-2xl font-bold tracking-wide text-purple-600',
                ),
                Text('uppercase + underline + shadow').className(
                  'uppercase underline text-shadow-sm text-lg',
                ),
                Text('ellipsis example that should truncate in one line')
                    .className('text-ellipsis w-[14rem]'),
              ],
            ),
          ),
          _section(
            'Layout utilities (Iterable.className)',
            [
              _box('A', Colors.red),
              _box('B', Colors.green),
              _box('C', Colors.blue),
              _box('D', Colors.purple),
              _box('E', Colors.indigo),
              _box('F', Colors.orange),
            ].className('grid grid-cols-2 md:grid-cols-3 gap-3'),
          ),
          _section(
            'Transforms',
            [
              Container(
                color: Colors.amber,
                child: const Center(child: Text('rotate-12')),
              ).className('w-[7rem] h-[4rem] rotate-12 rounded-md'),
              Container(
                color: Colors.lightBlue,
                child: const Center(child: Text('scale-110')),
              ).className('w-[7rem] h-[4rem] scale-110 rounded-md'),
              Container(
                color: Colors.lime,
                child: const Center(child: Text('translate-x-1/2')),
              ).className('w-[7rem] h-[4rem] translate-x-1/2 rounded-md'),
            ].className('flex flex-wrap gap-4'),
          ),
          _section(
            'Filters + Background + Gradient',
            Container(
              child: const Text(
                'blur + brightness + gradient',
                style: TextStyle(color: Colors.white),
              ),
            ).className(
              'p-4 rounded-lg from-blue-500 via-purple-500 to-pink-500 bg-gradient-to-r blur-sm brightness-110',
            ),
          ),
          _section(
            'Backdrop Blur (real visual check)',
            Stack(
              children: [
                Container(
                  height: 120,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFFEC4899)],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: 220,
                      height: 70,
                      alignment: Alignment.center,
                      child: const Text(
                        'backdrop-blur-md',
                        style: TextStyle(color: Colors.white),
                      ),
                    ).className('backdrop-blur-md rounded-lg'),
                  ),
                ),
              ],
            ),
          ),
          _section(
            'Animation + Transition',
            Container(
              child: const Center(
                child: Text(
                  'animate-pulse',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ).className(
              'w-[12rem] h-[4rem] bg-indigo-500 rounded-lg animate-pulse animate-normal duration-500 ease-in-out',
            ),
          ),
          _section(
            'Input classes',
            Column(
              children: [
                TextField(
                  decoration: const InputDecoration(hintText: 'Input sample'),
                ).className('input-md border-rounded focus:border-blue-500'),
                const SizedBox(height: 12),
                TextFormField(
                  decoration:
                      const InputDecoration(hintText: 'Form input sample'),
                ).className('input-sm border-outline hover:bg-gray-100'),
              ],
            ),
          ),
          _section(
            'Component presets (btn/card)',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Primary'),
                    ).className('btn btn-primary'),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Override'),
                    ).className('btn btn-primary bg-red-500'),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Card header').className('card-header'),
                      Text('Card body text with muted tone').className('card-body'),
                    ],
                  ),
                ).className('card'),
              ],
            ),
          ),
          _section(
            'Accessibility + Performance',
            Column(
              children: [
                Text('Focusable text').className('focusable focus-first'),
                const SizedBox(height: 8),
                Container(
                  color: Colors.black12,
                  child: const Text('lazy-load cache optimize-memory'),
                ).className(
                  'p-3 rounded-md lazy-load cache optimize-memory debounce-300 throttle-500',
                ),
              ],
            ),
          ),
          _section(
            'Variants: responsive + dark + hover + active',
            Container(
              child: const Center(
                child: Text(
                  'Try hover/active; resize for md; dark mode is enabled in app',
                ),
              ),
            ).className(
              'p-4 rounded-lg bg-blue-500 md:bg-green-500 dark:bg-purple-700 hover:bg-pink-500 active:bg-red-500 text-white',
            ),
          ),
        ],
      ),
    );
  }

  static Widget _section(String title, Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title).className('text-lg font-semibold mb-2'),
          child,
        ],
      ),
    );
  }

  static Widget _box(String label, Color color) {
    return Container(
      height: 70,
      color: color,
      alignment: Alignment.center,
      child: Text(
        label,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ).className('rounded-md');
  }
}
