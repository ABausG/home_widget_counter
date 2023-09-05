import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HomeWidget.setAppGroupId('group.es.antonborri.homeWidgetCounter');
  await HomeWidget.registerInteractivityCallback(backgroundCallback);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> backgroundCallback(Uri? uri) async {
  await HomeWidget.setAppGroupId('group.es.antonborri.homeWidgetCounter');

  if (uri?.host == 'increment') {
    await _increment();
  } else if (uri?.host == 'clear') {
    await _clear();
  }
}

const _countKey = 'counter';

Future<int> _increment() async {
  final oldValue = await _value;
  final newValue = oldValue + 1;
  await HomeWidget.saveWidgetData<int>(_countKey, newValue);
  await HomeWidget.updateWidget(iOSName: 'CounterWidget');
  return newValue;
}

Future<void> _clear() async {
  await HomeWidget.saveWidgetData(_countKey, null);
  await HomeWidget.updateWidget(iOSName: 'CounterWidget');
}

Future<int> get _value async {
  final value = await HomeWidget.getWidgetData<int>(_countKey, defaultValue: 0);
  return value!;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(
        useMaterial3: false,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _incrementCounter() async {
    await _increment();
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            FutureBuilder<int>(
              future: _value,
              builder: (_, snapshot) => Text(
                (snapshot.data ?? 0).toString(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            TextButton(
              onPressed: () async {
                await _clear();
                setState(() {});
              },
              child: const Text('Clear'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
