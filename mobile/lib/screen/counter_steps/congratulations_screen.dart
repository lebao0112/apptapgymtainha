import 'package:flutter/material.dart';

class CongratulationsScreen extends StatelessWidget {
  final int steps;
  final String time;
  final double kcal;
  final double km;

  const CongratulationsScreen({
    Key? key,
    required this.steps,
    required this.time,
    required this.kcal,
    required this.km,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(  // Wrap content in SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Trophy image and confetti effect
              Image.asset('assets/trophy.png'),  // Assuming the image is saved in assets
              SizedBox(height: 20),

              // Step count and congratulation message
              Text(
                '$steps Steps!',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Congratulations!\nYou’ve completed the step goal.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 20),

              // Stats (time, kcal, km)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StatCard(icon: Icons.timer, label: 'time', value: time),
                  StatCard(icon: Icons.local_fire_department, label: 'kcal', value: kcal.toStringAsFixed(1)),
                  StatCard(icon: Icons.directions_walk, label: 'km', value: km.toStringAsFixed(2)),
                ],
              ),
              SizedBox(height: 40),

              // Buttons for "Stop Step" and "Continue Steps"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);  // Navigate back to the home screen
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      backgroundColor: Colors.redAccent,
                    ),
                    child: Text('Stop Step'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);  // Go back and continue counting
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      backgroundColor: Colors.purple,
                    ),
                    child: Text('Continue Steps'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const StatCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.grey),
        SizedBox(height: 10),
        Text(value, style: TextStyle(fontSize: 18)),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
