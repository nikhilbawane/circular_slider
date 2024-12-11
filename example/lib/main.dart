import 'package:circular_slider/circular_slider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Circular Slider',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _value = 0.0;

  double _startAngle = 0.0;

  double _endAngle = 3.141 * 1.5;

  double _offset = 0.0;

  int _steps = 12;

  @override
  Widget build(BuildContext context) {
    CircularSlider(
      value: _value,
      startAngle: 0.0,
      endAngle: 3.141,
      radius: 160,
      knobBuilder: (context, angle) {
        return const Card(
          color: Colors.blue,
          shape: CircleBorder(),
        );
      },
      onChanged: (value) {
        setState(() {
          _value = value;
        });
      },
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Circular Slider'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: CircularSlider(
                startAngle: 0.0, // from 0 to 2π, greater than endAngle
                endAngle: 3.141, // from 0 to 2π, less than startAngle
                strokeWidth: 24.0, // width of the track

                // required
                radius: 160,
                value: _value, // a value from 0.0 to 1.0
                knobBuilder: (context, angle) {
                  return const Card(
                    color: Colors.blue,
                    shape: CircleBorder(),
                  );
                },
                onChanged: (value) {
                  // value obtained will always be between 0.0 and 1.0
                  setState(() {
                    _value = value;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Start Angle:'),
                          const SizedBox(height: 16.0),
                          Slider(
                            label: _startAngle.toStringAsFixed(2),
                            divisions: 360,
                            value: _startAngle,
                            min: 0.0,
                            max: 2 * 3.141,
                            onChanged: (value) {
                              if (value < _endAngle) {
                                setState(() => _startAngle = value);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('End Angle:'),
                          const SizedBox(height: 16.0),
                          Slider(
                            label: _endAngle.toStringAsFixed(2),
                            divisions: 360,
                            value: _endAngle,
                            min: 0.0,
                            max: 2 * 3.141,
                            onChanged: (value) {
                              if (value > _startAngle) {
                                setState(() => _endAngle = value);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Offset Radian:'),
                          const SizedBox(height: 16.0),
                          Slider(
                            label: _offset.toStringAsFixed(2),
                            divisions: 360,
                            value: _offset,
                            min: 0.0,
                            max: 2 * 3.141,
                            onChanged: (value) =>
                                setState(() => _offset = value),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Steps:'),
                          const SizedBox(height: 16.0),
                          Row(children: [
                            IconButton(
                              onPressed: () {
                                if (_steps == 0) return;
                                setState(() {
                                  _steps--;
                                });
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            const SizedBox(width: 16.0),
                            Text(_steps.toString()),
                            const SizedBox(width: 16.0),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _steps++;
                                });
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
