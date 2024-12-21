import 'package:doan_tapgymtainha/screen/exercise_sequence/completed_workout_screen.dart';
import 'package:doan_tapgymtainha/screen/exercise_sequence/record_video.dart';
import 'package:doan_tapgymtainha/screen/exercise_sequence/taking_break_sreen.dart';
import 'package:doan_tapgymtainha/shared/format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

import '../../provider/chalprogress_provider.dart';
import '../../provider/workout_timer_provider.dart';
import '../../service/api_challenge.dart';

class ExerciseTimerScreen extends StatefulWidget {
  List<dynamic> exercises;
  final int currentExerciseIndex;
  final Map<String, dynamic>? chalProgress;

  ExerciseTimerScreen(
      {super.key, required this.exercises, required this.currentExerciseIndex, this.chalProgress});

  @override
  State<ExerciseTimerScreen> createState() => _ExerciseTimerScreenState();
}

class _ExerciseTimerScreenState extends State<ExerciseTimerScreen> {
  late final VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  late final List<dynamic> exercises = widget.exercises;
  late int currentExerciseIndex = widget.currentExerciseIndex;
  late final int exerciseLength = exercises.length;
  late final String? videoUrl = widget.exercises[currentExerciseIndex]['videoUrl'];


  late final Map<String , dynamic>? chalProgress = widget.chalProgress;

  late int _remainingSeconds;
  Timer? _timer;
  bool isPaused = false;
  @override
  void initState() {
    super.initState();
    _remainingSeconds = exercises[currentExerciseIndex]['duration'];

    print("video url là: ${videoUrl}");
    if(!exercises[currentExerciseIndex]['isRep'])
      _startTimer();

    _videoPlayerController = VideoPlayerController.network(videoUrl.toString());
      _initializeVideoPlayerFuture =
          _videoPlayerController.initialize().then((_) {
        _videoPlayerController.setLooping(true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isPaused) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _timer?.cancel();
            _goToTakingBreakScreen(context, chalProgress);
          }
        });
      }
    });
  }

  void _togglePauseResume() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? chalprogress = widget.chalProgress;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30, right: 30, bottom: 5),
                  child: StepProgressIndicator(
                    totalSteps: exerciseLength,
                    currentStep: currentExerciseIndex,
                    size: 5,
                    selectedColor: Colors.orange,
                    unselectedColor: Colors.grey,
                  ),
                ),
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
            
                    // Exercise and Timer Text in the Center
                    Container(
                      margin: const EdgeInsets.only(top: 10, left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Động tác ${currentExerciseIndex+1}/$exerciseLength',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
            
                        ],
                      ),
                    ),
            
                    // Music Button and Rotate Screen Button on the Right
                    // Music Button and Camera Button on the Right
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10, right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[300], // Background color of the container
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Add action for music button here
                                },
                                icon: Icon(Icons.music_note_outlined),
                                color: Colors.black, // Icon color
                              ),
                              SizedBox(width: 8), // Space between the icons
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    //dau ! de ép kiều từ string? thành string
                                    MaterialPageRoute(builder: (context) => RecordVideoScreen(exerciseVideoUrl: videoUrl!)),
                                  );
                                },
                                icon: Icon(Icons.videocam),
                                color: Colors.black, // Icon color
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 100),

          // Video Player Section

          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              // Check if the videoUrl is valid
              if (videoUrl == null) {
                return Center(
                  child: Text(
                    "No video loaded",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                _videoPlayerController.play();
                return SizedBox(
                  height: 200,
                  child: AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  ),
                );
              } else {
                // If the VideoPlayerController is still initializing, show a loading spinner.
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),


          SizedBox(height: 100), // Sp

          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 20),
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Exercise Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      exercises[currentExerciseIndex]['name'],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 3),
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white, // Border color
                          width: 1.5, // Border width
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.question_mark),
                        color: Colors.white,
                        iconSize: 14,
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                !exercises[currentExerciseIndex]['isRep'] ?
                Text(
                  Format.formatDuration(_remainingSeconds),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ) :
                Text(
                  "x ${exercises[currentExerciseIndex]['reps']}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                )
                ,
                // Text(
                //   'x 10',
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontWeight: FontWeight.bold,
                //     fontSize: 40,
                //   ),
                // ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: currentExerciseIndex != 0, // Chỉ hiển thị khi currentExerciseIndex khác 0
                      maintainSize: true, // Duy trì kích thước của widget ngay cả khi ẩn
                      maintainAnimation: true,
                      maintainState: true,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            currentExerciseIndex--;
                            _goToExerciseTimerScreen(context);
                          },
                          icon: Icon(Icons.skip_previous),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    !exercises[currentExerciseIndex]['isRep'] ?
                    ElevatedButton(
                      onPressed: _togglePauseResume,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      ),
                      child: Icon(
                        isPaused ? Icons.play_arrow : Icons.pause, // Toggle icon
                        color: Colors.white,
                        size: 24,
                      ),
                    ) :
                    ElevatedButton(
                      onPressed: () {
                        _goToTakingBreakScreen(context, chalprogress);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      ),
                      child: Icon(
                        Icons.check_sharp, // Toggle icon
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 20), // Space between buttons

                    // Next Button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          _goToTakingBreakScreen(context, chalprogress);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => TakingBreakSreen(
                          //       exercises: [],
                          //     ),
                          //   ),
                          // );
                        },
                        icon: Icon(Icons.skip_next),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _goToTakingBreakScreen(BuildContext context, Map<String, dynamic>? chalProgress) {
    if (currentExerciseIndex < exercises.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TakingBreakSreen(
            exercises: exercises,
            currentExerciseIndex: currentExerciseIndex + 1,
            chalProgress: chalProgress,
          ),
        ),
      );
    } else{
        completeWorkout(context, chalProgress?['_id']);


        final workoutTimer = Provider.of<WorkoutTimerProvider>(context, listen: false);
        workoutTimer.stopTimer();
        workoutTimer.addHistory();
        final totalTime = workoutTimer.totalTime;

        Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CompletedWorkoutScreen(exercises: exercises, chalProgress: chalProgress),
        ),
      );
    }
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

  void completeWorkout(BuildContext context, String? chalProgressId) async {
    if(chalProgressId == null || chalProgressId.isEmpty)
      return;

    print("chalprogress id là: ${chalProgressId}");
    // await ApiChallenge.increaseChalProgress(chalProgressId);
     Provider.of<ChalprogressProvider>(context, listen: false).increaseChalProgress(chalProgressId);
  }

}
