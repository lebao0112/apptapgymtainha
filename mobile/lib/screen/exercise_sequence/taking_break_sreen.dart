import 'package:doan_tapgymtainha/screen/exercise_sequence/exercise_timer_screen.dart';
import 'package:doan_tapgymtainha/screen/workoutdetail_screen.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:video_player/video_player.dart';

class TakingBreakSreen extends StatefulWidget {
  List<dynamic>exercises;
  int currentExerciseIndex;

  TakingBreakSreen( {required this.exercises, required this.currentExerciseIndex});

  @override
  State<TakingBreakSreen> createState() => _TakingBreakSreenState();
}

class _TakingBreakSreenState extends State<TakingBreakSreen> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  int totalTimeInSeconds = 20;
  int currentTime = 0;
  late final List<dynamic> exercises = widget.exercises;
  late final int currentExerciseIndex = widget.currentExerciseIndex; 

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: totalTimeInSeconds),
    )..addListener(() {
      setState(() {});
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
    int remainingTime = (totalTimeInSeconds * _controller.value).ceil();

    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,

                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NEXT 2/6',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                          'ARM RAISES',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  Text(
                    'X14',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 80),
            Text(
              'Rest',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
            ),
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
            SizedBox(height: 18),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    minimumSize: Size(160, 50),
                  ),
                  onPressed: () {
                    _controller.reset();
                    _controller.reverse(from: 1.0);
                  },
                  child: Text(
                    'Rest more',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                SizedBox(height: 10),

                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(160, 50),
                  ),
                  onPressed: () {
                    _goToExerciseTimerScreen(context);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ExerciseTimerScreen(exercises: [],),
                    //   ),
                    // );
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),// Sp




          ],
        ),
      ),
    );
  }

  void _goToExerciseTimerScreen(
    BuildContext context,
  ) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseTimerScreen(
          exercises: exercises,
          currentExerciseIndex: currentExerciseIndex,
        ),
      ),
    );
  }

}
