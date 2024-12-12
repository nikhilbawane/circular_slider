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
                value: _value,
                min: 0.0,
                max: 1.0,
                steps: _steps,
                offsetRadian: _offset,
                startAngle: _startAngle,
                endAngle: _endAngle,
                radius: 160,
                strokeWidth: 42,
                notchRingOffset: 0.0,
                trackColor: Colors.grey.shade200,
                knobSize: const Size.square(50.0),
                knobBuilder: (context, angle) {
                  return Card(
                    shape: const CircleBorder(
                      eccentricity: 0.2,
                      side: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        angle.toStringAsFixed(0),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                },
                markers: [
                  ...List.generate(
                    _steps ~/ 5,
                    (index) => CircularSliderMarker(
                      marker: const Icon(Icons.star),
                      size: const Size.square(24.0),
                      stepIndex: (index * 5).toDouble(),
                    ),
                  ),
                  const CircularSliderMarker(
                    marker: Icon(Icons.favorite),
                    size: Size.square(24.0),
                    value: 0.1,
                    lockRotation: false,
                  ),
                ],
                notchGroups: [
                  ...List.generate(
                    _steps,
                    (index) => CircularSliderNotchGroup(
                      stepIndex: index.toDouble(),
                      spacing: 16.0,
                      notches: [
                        CircularSliderNotch(
                          radius: _value == (index / _steps) ? 4.0 : 2.0,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                  const CircularSliderNotchGroup(
                    stepIndex: 1,
                    spacing: 16.0,
                    notches: [
                      CircularSliderNotch(
                        radius: 4.0,
                        color: Colors.red,
                        filled: false,
                        strokeWidth: 2.0,
                      ),
                      CircularSliderNotch(radius: 2.0, color: Colors.black),
                      CircularSliderNotch(radius: 2.0, color: Colors.purple),
                      CircularSliderNotch(radius: 2.0, color: Colors.orange),
                    ],
                  ),
                  const CircularSliderNotchGroup(
                    stepIndex: 2,
                    spacing: 16.0,
                    notches: [
                      CircularSliderNotch(radius: 2.0, color: Colors.red),
                      CircularSliderNotch(radius: 2.0, color: Colors.green),
                    ],
                  ),
                ],
                segments: const [
                  CircularSliderSegment(
                    color: Colors.red,
                    start: 0,
                    length: 0.2,
                    width: 42.0,
                  ),
                  CircularSliderSegment(
                    color: Colors.yellow,
                    start: 0.2,
                    length: 0.2,
                    width: 42.0,
                  ),
                  CircularSliderSegment(
                    color: Colors.green,
                    start: 0.4,
                    length: 0.2,
                    width: 42.0,
                  ),
                ],
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
