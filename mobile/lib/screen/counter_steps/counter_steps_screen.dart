import 'package:flutter/material.dart';
import 'package:pedometer_2/pedometer_2.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class CounterStepsScreen extends StatefulWidget {
  @override
  _CounterStepsScreenState createState() => _CounterStepsScreenState();
}

class _CounterStepsScreenState extends State<CounterStepsScreen> {
  final Pedometer pedometer = Pedometer();
  late Stream<int> _stepCountStream;
  int _steps = 0;
  int _startingStepsToday = 0;
  double _kcal = 0.0;
  double _km = 0.0;
  bool _isCounting = false;
  Timer? _timer;
  Duration _duration = Duration();
  int _stepGoal = 6000;
  List<int> _last7DaysSteps = List.filled(7, 0);
  List<String> _dayLabels = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  int _lastStepCount = 0;
  bool _initialLoadCompleted = false;

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndStartListening();
    _fetchCurrentDaySteps();
    _fetchLast7DaysSteps();
  }

  Future<void> _requestPermissionsAndStartListening() async {
    var status = await Permission.activityRecognition.status;
    if (status.isDenied) {
      status = await Permission.activityRecognition.request();
    }

    if (status.isGranted) {
      _startListening();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission denied. Step counting will not work.')),
      );
    }
  }

  void _startListening() {
    _stepCountStream = pedometer.stepCountStream();
    _stepCountStream.listen(_onStepCount).onError((error) {
      print("Error: $error");
    });
  }

  Future<void> _fetchCurrentDaySteps() async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    _startingStepsToday = await pedometer.getStepCount(from: startOfDay, to: now);
    _lastStepCount = _startingStepsToday;
    setState(() {
      _steps = _startingStepsToday;
      _kcal = _steps * 0.04;
      _km = _steps * 0.0008;
      _initialLoadCompleted = true;
    });
  }

  void _onStepCount(int stepCount) {
    if (!_initialLoadCompleted) return;

    setState(() {
      if (_isCounting) {
        int stepDifference = stepCount - _lastStepCount;

        if (stepDifference > 0 && stepDifference < 1000) {
          _steps += stepDifference;
          _kcal = _steps * 0.04;
          _km = _steps * 0.0008;
        }
        _lastStepCount = stepCount;
      }
    });
  }

  Future<void> _fetchLast7DaysSteps() async {
    DateTime now = DateTime.now();
    for (int i = 1; i <= 7; i++) {
      DateTime from = DateTime(now.year, now.month, now.day - i);
      DateTime to = from.add(Duration(days: 1));
      int steps = await pedometer.getStepCount(from: from, to: to);
      setState(() {
        _last7DaysSteps[7 - i] = steps;
      });
    }
  }

  void _startStopCounter() {
    setState(() {
      if (!_isCounting) {
        _fetchCurrentDaySteps();
        _startTimer();
      } else {
        _timer?.cancel();
      }
      _isCounting = !_isCounting;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _duration += Duration(seconds: 1);
      });
    });
  }

  void _showStepDetails(int dayIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Steps on ${_dayLabels[dayIndex]}"),
          content: Text("You walked ${_last7DaysSteps[dayIndex]} steps."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int todayIndex = now.weekday % 7;

    List<String> dayLabels = [];
    for (int i = 1; i <= 7; i++) {
      int dayIndex = (todayIndex - i) % 7;
      dayLabels.insert(0, _dayLabels[dayIndex < 0 ? dayIndex + 7 : dayIndex]);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircularStepProgressIndicator(
              totalSteps: _stepGoal,
              currentStep: _steps,
              stepSize: 10,
              selectedColor: Colors.purple,
              unselectedColor: Colors.grey.shade200,
              padding: 0,
              width: 150,
              height: 150,
              selectedStepSize: 15,
              roundedCap: (_, __) => true,
              child: Center(
                child: Text(
                  '$_steps\n/$_stepGoal',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard("Time", _formatDuration(_duration)),
                _buildStatCard("Kcal", _kcal.toStringAsFixed(1)),
                _buildStatCard("Km", _km.toStringAsFixed(2)),
              ],
            ),
            SizedBox(height: 20),
            Text("Your Progress", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(7, (index) {
                  return GestureDetector(
                    onTap: () => _showStepDetails(index),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.purple),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "${_last7DaysSteps[index]}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                          Text(dayLabels[index], style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startStopCounter,
              child: Text(_isCounting ? "Stop" : "Start"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
