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
  double _value1 = 0.0;
  double _value2 = 0.0;
  double _value3 = 0.0;
  double _value4 = 0.0;

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
            child: DefaultTabController(
              length: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TabBar(
                    isScrollable: true,
                    tabs: [
                      Tab(
                        child: Text('Slider 1'),
                      ),
                      Tab(
                        child: Text('Slider 2'),
                      ),
                      Tab(
                        child: Text('Slider 3'),
                      ),
                      Tab(
                        child: Text('Slider 4'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildSlider1(),
                        _buildSlider2(),
                        _buildSlider3(),
                        _buildSlider4(),
                      ],
                    ),
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

  Widget _buildSlider1() {
    return CircularSlider(
      value: _value1,
      min: 0.0,
      max: 1.0,
      steps: _steps,
      offsetRadian: _offset,
      startAngle: _startAngle,
      endAngle: _endAngle,
      radius: 160,
      notchRingOffset: 0.0,
      track: CircularSliderTrack(
        color: Colors.grey.shade200,
        strokeWidth: 42.0,
      ),
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
              (angle * 180 / 3.141).toStringAsFixed(0),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
      onChanged: (value) {
        setState(() {
          _value1 = value;
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
                radius: _value1 == (index / _steps) ? 4.0 : 2.0,
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
          strokeWidth: 42.0,
        ),
        CircularSliderSegment(
          color: Colors.yellow,
          start: 0.2,
          length: 0.2,
          strokeWidth: 42.0,
        ),
        CircularSliderSegment(
          color: Colors.green,
          start: 0.4,
          length: 0.2,
          strokeWidth: 42.0,
        ),
      ],
    );
  }

  Widget _buildSlider2() {
    return CircularSlider(
      value: _value2,
      min: 0.0,
      max: 1.0,
      steps: _steps,
      offsetRadian: _offset,
      startAngle: _startAngle,
      endAngle: _endAngle,
      radius: 160,
      notchRingOffset: 84.0,
      track: CircularSliderTrack(
        color: Colors.grey.shade200,
        strokeWidth: 42.0,
      ),
      knobSize: const Size(32.0, 64.0),
      knobAlignment: 0.5,
      lockKnobRotation: true,
      knobBuilder: (context, angle) {
        return const Card(
          color: Colors.blue,
          margin: EdgeInsets.zero,
          shape: StadiumBorder(),
          child: Align(
            alignment: Alignment(0.0, -0.8),
            child: Icon(
              Icons.arrow_upward,
              color: Colors.white,
            ),
          ),
        );
      },
      onChanged: (value) {
        setState(() {
          _value2 = value;
        });
      },
      notchGroups: [
        ...List.generate(
          _steps + 1,
          (index) => CircularSliderNotchGroup(
            stepIndex: index.toDouble(),
            spacing: 16.0,
            notches: [
              CircularSliderNotch(
                radius: _value2 == (index / _steps) ? 4.0 : 2.0,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ],
      segments: [
        CircularSliderSegment(
          color: Colors.blue,
          start: 0,
          length: _value2.clamp(0.00001, 1.0),
          strokeWidth: 42.0,
        ),
      ],
    );
  }

  Widget _buildSlider3() {
    bool inRegion = false;

    if (_value3 >= (0.25 * 50) && _value3 <= (0.75 * 50)) {
      inRegion = true;
    }

    return CircularSlider(
      value: _value3,
      min: 0.0,
      max: 50.0,
      steps: _steps,
      offsetRadian: _offset,
      startAngle: _startAngle,
      endAngle: _endAngle,
      radius: 160,
      notchRingOffset: 84.0,
      track: const CircularSliderTrack(
        color: Colors.red,
        strokeWidth: 42.0,
      ),
      showArrow: false,
      interactionMode: InteractionMode.both,
      knobSize: inRegion ? const Size.square(72.0) : const Size.square(42.0),
      knobBuilder: (context, angle) {
        return Card(
          elevation: inRegion ? 8.0 : null,
          shape: const CircleBorder(),
        );
      },
      onChanged: (value) {
        setState(() {
          _value3 = value;
        });
      },
      segments: const [
        CircularSliderSegment(
          color: Colors.white,
          start: 0.25,
          length: 0.5,
          strokeWidth: 4.0,
        ),
      ],
    );
  }

  Widget _buildSlider4() {
    final notchColor = Color.lerp(
          Colors.pink,
          Colors.purple,
          _value4,
        ) ??
        Colors.red;

    return CircularSlider(
      value: _value4,
      min: 0.0,
      max: 1.0,
      steps: _steps,
      offsetRadian: _offset,
      startAngle: _startAngle,
      endAngle: _endAngle,
      radius: 160,
      track: CircularSliderTrack(
        color: Colors.grey.shade200,
        strokeWidth: 42.0,
      ),
      showArrow: false,
      interactionMode: InteractionMode.knob,
      knobSize: const Size.square(42.0),
      knobBuilder: (context, angle) {
        return const Card(
          shape: CircleBorder(),
        );
      },
      onChanged: (value) {
        setState(() {
          _value4 = value;
        });
      },
      notchGroups: [
        CircularSliderNotchGroup(
          value: _value4,
          spacing: 16.0,
          notches: [
            CircularSliderNotch(
              radius: 4.0,
              color: notchColor,
            ),
            CircularSliderNotch(
              radius: 3.0,
              color: notchColor,
            ),
            CircularSliderNotch(
              radius: 2.0,
              color: notchColor,
            ),
          ],
        )
      ],
      segments: [
        CircularSliderSegment(
          gradientColors: const [Colors.pink, Colors.purple],
          gradientMode: GradientMode.circle,
          start: 0.0,
          length: _value4,
          strokeWidth: 42.0,
        ),
      ],
    );
  }
}
