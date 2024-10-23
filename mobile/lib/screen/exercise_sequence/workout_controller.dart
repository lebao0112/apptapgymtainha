// import 'package:doan_tapgymtainha/screen/exercise_sequence/exercise_timer_screen.dart';
// import 'package:doan_tapgymtainha/screen/exercise_sequence/ready_workout_sreen.dart';
// import 'package:flutter/material.dart';

// class WorkoutController {
//   int currentExerciseIndex = 0;
//   final List<dynamic> exercises;

//   WorkoutController(this.exercises);

//   void startWorkout(BuildContext context) {
//     // Start with the first exercise
//     goToExerciseScreen(context, exercises[currentExerciseIndex]);
//   }

//   // void goToReadyScreen(BuildContext context, dynamic exercise) {
//   //   Navigator.pushReplacement(
//   //     context,
//   //     MaterialPageRoute(
//   //         builder: (context) => ReadyWorkoutSreen(exercise: exercise)),
//   //   );
//   // }

//   void goToExerciseScreen(BuildContext context, dynamic exercise) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//           builder: (context) => ExerciseTimerScreen(exercise: exercise)),
//     );
//   }

//   // void goToBreakScreen(BuildContext context) {
//   //   if (currentExerciseIndex < exercises.length - 1) {
//   //     // Proceed to the next exercise after a break
//   //     Navigator.pushReplacement(
//   //       context,
//   //       MaterialPageRoute(builder: (context) => TakingBreakScreen()),
//   //     );
//   //   } else {
//   //     // Workout completed
//   //     Navigator.pushReplacement(
//   //       context,
//   //       MaterialPageRoute(builder: (context) => WorkoutCompleteScreen()),
//   //     );
//   //   }
//   // }

//   // void nextExercise(BuildContext context) {
//   //   if (currentExerciseIndex < exercises.length - 1) {
//   //     currentExerciseIndex++;
//   //     goToReadyScreen(context, exercises[currentExerciseIndex]);
//   //   } else {
//   //     // Finish the workout
//   //     goToCompletionScreen(context);
//   //   }
//   // }
// }
