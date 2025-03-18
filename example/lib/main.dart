import 'package:flutter/material.dart';
import 'package:flutterwind/flutterwind.dart';

void main() {
  runApp(const FlutterWind(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const App(),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo'),
        ),
        body: [
          const Text("Project UI/UX")
              .className('text-black font-semibold text-3xl'),
          Container(
            child: [
              Container(
                child: Text("Board").className(
                    "text-black font-semibold flex items-center justify-center"),
              )
                  .className(
                      "px-4 py-1 bg-white rounded-md w-[19%] flex items-center justify-center")
                  .withGestures(
                    onTap: () => print("Board"),
                  ),
              Container(
                child: Text("List").className("text-black font-semibold"),
              ).className(
                  "px-4 py-1 rounded-md w-[19%] flex items-center justify-center"),
              Container(
                child: Text("Timeline").className("text-black font-semibold"),
              ).className(
                  "px-4 py-1 rounded-md w-[19%] flex items-center justify-center"),
            ].className(
                "flex flex-row bg-[#e0e0e0] rounded-lg items-start justify-between gap-2 p-1"),
          ).className("w-full px-2"),
          [
            Container(
              child: Text("Project UI/UX"),
            ).className(
                'p-4 bg-purple-300 rounded-lg shadow-lg w-[35%] h-[80px]'),
            Container(
              child: [
                Container(
                  child: Icon(Icons.add),
                ).className("bg-black-300 rounded-full p-2"),
                Text("Item 3"),
              ].className("flex flex-col items-start justify-center gap-2"),
            ).className(
                'p-4 bg-[#e376a0] rounded-lg shadow-lg w-[35%] h-[80px]'),
          ].className('flex flex-row items-center justify-center w-full gap-2'),
        ].className(
            'flex flex-col items-start justify-start gap-3 p-4 w-full h-auto '),
      ),
    );
  }
}
