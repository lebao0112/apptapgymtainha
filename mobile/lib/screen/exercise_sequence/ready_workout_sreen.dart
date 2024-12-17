import 'package:doan_tapgymtainha/screen/exercise_sequence/exercise_timer_screen.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ReadyWorkoutSreen extends StatefulWidget {
  List<dynamic> exercises;
  final Map<String, dynamic>? chalProgress;

  ReadyWorkoutSreen({required this.exercises, this.chalProgress});


  @override
  State<ReadyWorkoutSreen> createState() => _ReadyWorkoutSreenState();
}

class _ReadyWorkoutSreenState extends State<ReadyWorkoutSreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  int totalTimeInSeconds = 20;
  int currentTime = 0;
  late int remainingTime;
  late final List<dynamic> exercises = widget.exercises;
  late final int currentExerciseIndex = 0;
  late final Map<String , dynamic>? chalProgress = widget.chalProgress;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: totalTimeInSeconds),
    )..addListener(() {
        setState(() {
          remainingTime =
              (_controller.duration!.inSeconds * _controller.value).toInt();
          if (remainingTime == 0) {
            _goToExerciseTimerScreen(context, chalProgress); // Trigger event when time is up
          }
        });
      });

    // Bắt đầu animation đếm ngược từ 1.0 về 0.0
    _controller.reverse(from: 1.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? chalprogress = widget.chalProgress;
    int remainingTime = (totalTimeInSeconds * _controller.value).ceil();

    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close),
                    color: Colors.black,
                  ),
                ),

                Column(
                  children: [
                    // Music Button
                    Container(
                      margin: const EdgeInsets.only(top: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Colors
                            .grey[300], // Background color of the music button
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Add action for music button here
                        },
                        icon: Icon(Icons.music_note_outlined),
                        color: Colors.black, // Icon color
                      ),
                    ),
                    SizedBox(height: 10), // Spacing between buttons

                    // Rotate Screen Button directly below the Music Button
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[
                            300], // Background color of the rotate screen button
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Add action for rotate screen button here
                        },
                        icon: Icon(Icons.screen_rotation),
                        color: Colors.black, // Icon color
                      ),
                    ),
                  ],
                ),

                // Exercise and Timer Text in the Center
              ]),
          SizedBox(height: 40),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Get Ready!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircularStepProgressIndicator(
                    totalSteps: 100,
                    currentStep: 100 - (100 * _controller.value).toInt(),
                    stepSize: 1,
                    selectedColor: Colors.orange,
                    unselectedColor: Colors.white,
                    padding: 0,
                    width: 180,
                    height: 180,
                    selectedStepSize: 15,
                    unselectedStepSize: 17,
                    roundedCap: (_, __) => false,
                  ),
                  Text(
                    '$remainingTime',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 25),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(160, 50),
                ),
                onPressed: () {
                    _goToExerciseTimerScreen(context, chalprogress);
                },
                child: Text(
                  'START',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              )
            ],
          )
        ],
      ),
    );
  }


  void _goToExerciseTimerScreen(
      BuildContext context, Map<String, dynamic>? chalprogress
      ) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseTimerScreen(
          exercises: exercises,
          currentExerciseIndex: currentExerciseIndex,
          chalProgress: chalprogress,
        ),
      ),
    );
  }
}
