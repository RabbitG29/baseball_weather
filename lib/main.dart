import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '야구장 날씨',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '야구장 날씨 알아보기'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _getWeatherInfo() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                ElevatedButton(
                    onPressed: () {}, child: const Text("인천SSG랜더스필드")),
                ElevatedButton(
                    onPressed: () {}, child: const Text("서울종합운동장 야구장")),
                ElevatedButton(onPressed: () {}, child: const Text("수원KT위즈파크")),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                ElevatedButton(onPressed: () {}, child: const Text("창원NC파크")),
                ElevatedButton(
                    onPressed: () {}, child: const Text("광주기아챔피언스필드")),
                ElevatedButton(onPressed: () {}, child: const Text("사직 야구장")),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                ElevatedButton(
                    onPressed: () {}, child: const Text("대구삼성라이온즈파크")),
                ElevatedButton(
                    onPressed: () {}, child: const Text("대전한화생명이글스파크")),
                ElevatedButton(onPressed: () {}, child: const Text("고척 스카이돔")),
              ],
            ),
            const SizedBox(height: 10),
            const Expanded(
              child: Center(
                child: Text(
                  '날씨 결과값',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
