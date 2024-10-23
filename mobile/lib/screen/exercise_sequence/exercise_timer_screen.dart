import 'package:doan_tapgymtainha/screen/exercise_sequence/completed_workout_screen.dart';
import 'package:doan_tapgymtainha/screen/exercise_sequence/taking_break_sreen.dart';
import 'package:doan_tapgymtainha/screen/workoutdetail_screen.dart';
import 'package:flutter/material.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:video_player/video_player.dart';

class ExerciseTimerScreen extends StatefulWidget {
  List<dynamic> exercises;
  final int currentExerciseIndex;

  ExerciseTimerScreen(
      {super.key, required this.exercises, required this.currentExerciseIndex});

  @override
  State<ExerciseTimerScreen> createState() => _ExerciseTimerScreenState();
}

class _ExerciseTimerScreenState extends State<ExerciseTimerScreen> {
  late final VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  late final List<dynamic> exercises = widget.exercises;
  late final int currentExerciseIndex = widget.currentExerciseIndex;
  late final int exerciseLength = exercises.length;
  late final String videoUrl = widget.exercises[currentExerciseIndex]['videoUrl'];

  // @override
  // void initState() {
  //   super.initState();
  //    _videoPlayerController = VideoPlayerController.network(videoUrl);
  //   _initializeVideoPlayerFuture =
  //       _videoPlayerController.initialize().then((_) {
  //     _videoPlayerController.setLooping(true);
  //     setState(() {});
  //   });
  // }

  // @override
  // void dispose() {
  //   _videoPlayerController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
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
          Container(
            margin: const EdgeInsets.only(left: 30, right: 30, bottom: 5),
            child: StepProgressIndicator(
              totalSteps: exerciseLength,
              currentStep: currentExerciseIndex + 1,
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
                      'Exercises ${currentExerciseIndex+1}/$exerciseLength',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '00:15',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Music Button and Rotate Screen Button on the Right
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
            ],
          ),
          SizedBox(height: 100), // Sp

          // Video Player Section
        
          // FutureBuilder(
          //   future: _initializeVideoPlayerFuture,
          //   builder: (context, snapshot) {
          //     // Check if the videoUrl is valid
          //     if (videoUrl == null || videoUrl.isEmpty) {
          //       return Center(
          //         child: Text(
          //           "No video loaded",
          //           style: TextStyle(color: Colors.black, fontSize: 16),
          //         ),
          //       );
          //     }

          //     if (snapshot.connectionState == ConnectionState.done) {
          //       _videoPlayerController.play();
          //       return AspectRatio(
          //         aspectRatio: _videoPlayerController.value.aspectRatio,
          //         child: VideoPlayer(_videoPlayerController),
          //       );
          //     } else {
          //       // If the VideoPlayerController is still initializing, show a loading spinner.
          //       return const Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }
          //   },
          // ),


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

                // Timer Display
                Text(
                  '00:25',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                SizedBox(height: 20),

                // Control Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Action for next button
                        },
                        icon: Icon(Icons.skip_previous),
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(width: 20),
                    // Pause Button
                    ElevatedButton(
                      onPressed: () {
                        // Action for pause button
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      ),
                      child: Icon(
                        Icons.pause,
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
                          _goToTakingBreakScreen(context);
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

  void _goToTakingBreakScreen(BuildContext context) {
    if (currentExerciseIndex < exercises.length - 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TakingBreakSreen(
            exercises: exercises,
            currentExerciseIndex: currentExerciseIndex + 1,
          ),
        ),
      );
    } else{
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CompletedWorkoutScreen(),
        ),
      );
    }
  }
}
