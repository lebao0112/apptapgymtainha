import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompletedWorkoutScreen extends StatelessWidget {
  const CompletedWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "HOÀN THÀNH",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            Text(
              "<workout name>",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatsCard(context, '16', 'Exercise'),
                _buildStatsCard(context, '0', 'Calories'),
                _buildStatsCard(context, '12', 'Duration'),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            const Text(
              "Bạn cảm thấy thế nào",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white
              )
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space widgets evenly
              children: [
                buildDifficultyCircle('Dễ', Colors.green),
                buildDifficultyCircle('Thường', Colors.orange),
                buildDifficultyCircle('Khó', Colors.red),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: double.infinity,

              child: TextButton(

                  onPressed: () {

                  },
                  child: const Text(''
                      'KẾT THÚC',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.orange), // Background color
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.white),padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0), // Adjust padding here
                  ),
                    // Text color
                  ),
              ),
            )
          ],
        ),
      ),
    );

  }

  Widget _buildStatsCard(BuildContext context, String stats, String nameStats){
    return(
      Column(
        children: [
          Text(
            stats,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white
            ),
          ),
          Text(
            nameStats,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white
            ),
          )
        ],
      )
    );
  }

  Widget buildDifficultyCircle(String label, Color color) {
    return Container(
      width: 75, // Width of the circle
      height: 75, // Height of the circle
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle, // Circular shape
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}