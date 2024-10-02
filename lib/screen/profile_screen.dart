import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          elevation: 10,
          color: Colors.amber,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://www.planetsport.com/image-library/square/1200/c/cristiano-ronaldo-portugal-5-june-2022.jpg',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Name: Phạm Đức Tài', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                Text('Email: pductai14@gmail.com', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                Text('Phone: 0927749820', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
