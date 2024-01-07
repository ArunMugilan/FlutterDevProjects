import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  final String name;
  final int age;
  final String matricsNumber;
  final bool hideMenstruationOption;
  final String gender;

  const MenuScreen({super.key,
    required this.name,
    required this.age,
    required this.matricsNumber,
    this.hideMenstruationOption = false,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'STUDENT HEALTHCARE MENU',
          style: TextStyle(color: Colors.indigo[300]),
        ),
        centerTitle: true,
        backgroundColor: Colors.tealAccent,
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/v870-tang-37.jpg'),
            fit: BoxFit.fill, // or BoxFit.fill
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome, $name!',
                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Age: $age',
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Matrics Number: $matricsNumber',
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 30.0),
              const Text(
                'These are the functions offered in the app',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 30.0),
              if (gender == 'Female' && !hideMenstruationOption)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/menstruationTracker');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                  ),
                  child: const Text('Menstruation Cycle Tracker', style: TextStyle(color: Colors.indigo)),
                ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/healthTracker');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                ),
                child: const Text('Health Tracker & Symptom Checker', style: TextStyle(color: Colors.indigo)),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/tips&tricks');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                ),
                child: const Text('Health Tips & Tricks', style: TextStyle(color: Colors.indigo)),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/appointment');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                ),
                child: const Text('Make an appointment', style: TextStyle(color: Colors.indigo)),
              ),
              // Add more menu options as needed
            ],
          ),
        ),
      ),
    );
  }
}
