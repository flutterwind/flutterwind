import 'package:flutter/material.dart';
import 'package:flutterwind_core/flutterwind.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0;

  setSelectedTab(int index) {
    selectedTab = index;
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo'),
      ),
      body: [
        const Text("Project UI/UX")
            .className('text-red-500 font-semibold text-3xl'),
        Container(
          child: [
            Container(
              child: const Text("Board")
                  .className("text-black font-semibold text-center"),
            )
                .className(cn({
                  'bg-white': selectedTab == 0
                }, 'px-4 py-1 rounded-md w-[19%] flex items-center justify-center transition-all duration-10 ease-in-out'))
                .withGestures(
                  onTap: () => setSelectedTab(0),
                ),
            Container(
              child: const Text("List")
                  .className("text-black font-semibold text-center"),
            )
                .className(cn({
                  'bg-white': selectedTab == 1
                }, "px-4 py-1 rounded-md w-[19%] flex items-center justify-center transition-all duration-10 ease-in-out"))
                .withGestures(
                  onTap: () => setSelectedTab(1),
                ),
            Container(
              child: const Text("Timeline")
                  .className("text-black font-semibold text-center"),
            )
                .className(cn({
                  'bg-white': selectedTab == 2
                }, "px-4 py-1 rounded-md w-[19%] flex items-center justify-center transition-all duration-10 ease-in-out"))
                .withGestures(
                  onTap: () => setSelectedTab(2),
                ),
          ].className(
              "flex flex-row bg-[#e0e0e0] rounded-lg items-start justify-between gap-2 p-1"),
        ).className("w-full px-2"),
        [
          Container(
            child: const Text("Box1"),
          )
              .className(
                  'p-4 bg-purple-300 rounded-lg shadow-lg w-[35%] h-[80px]')
              .colSpan(2),
          Container(
            child: const Text("Box1"),
          )
              .className(
                  'p-4 bg-purple-300 rounded-lg shadow-lg w-[35%] h-[80px]')
              .colSpan(1),
          Container(
            child: [
              Container(
                child: const Icon(Icons.add),
              ).className("bg-black-300 rounded-full p-2"),
              const Text("Item 3"),
            ].className("flex flex-col items-start justify-center gap-2"),
          )
              .className(
                  'p-4 bg-[#e376a0] rounded-lg shadow-lg w-[35%] h-[80px]')
              .colSpan(1),
        ].className(
            'grid grid-cols-2 gap-2 w-full items-center justify-center'),
      ].className(
          'flex flex-col items-start justify-start gap-3 p-4 w-full h-auto '),
    );
  }
}
