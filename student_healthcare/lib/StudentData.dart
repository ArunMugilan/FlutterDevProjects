import 'package:flutter/material.dart';
import 'menuScreen.dart';

class StudentInfoScreen extends StatefulWidget {
  const StudentInfoScreen({super.key});

  @override
  _StudentInfoScreenState createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  String name = '';
  int age = 0;
  String matricsNumber = '';
  String gender = '';

  void _submitForm() {
    if (name.isEmpty || age == 0 || matricsNumber.isEmpty || gender.isEmpty) {
      // Show alert if any field is empty
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Incomplete Form'),
            content: const Text('Please complete the form before submitting.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MenuScreen(
            name: name,
            age: age,
            matricsNumber: matricsNumber,
            gender: gender,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('STUDENT HEALTHCARE SYSTEM', style: TextStyle(color: Colors.indigo[300]),),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Welcome to your Healthcare App !",
                style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
              const Text(
                "with this app you can track your health even in your busy days.",
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.indigo),
              ),
              const SizedBox(height: 25.0),
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text("Student Information",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo)),
                      const SizedBox(height: 16.0),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            age = int.tryParse(value) ?? 0;
                          });
                        },
                        decoration: const InputDecoration(labelText: 'Age'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            matricsNumber = value;
                          });
                        },
                        decoration:
                            const InputDecoration(labelText: 'Matrics Number'),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Radio(
                            value: 'Male',
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value.toString();
                              });
                            },
                          ),
                          const Text('Male'),
                          Radio(
                            value: 'Female',
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value.toString();
                              });
                            },
                          ),
                          const Text('Female'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.indigo),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
