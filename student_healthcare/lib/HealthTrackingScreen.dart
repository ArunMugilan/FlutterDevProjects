import 'package:flutter/material.dart';
import 'AppointmentScreen.dart';

class HealthTrackingScreen extends StatefulWidget {
  @override
  _HealthTrackingScreenState createState() => _HealthTrackingScreenState();
}

class _HealthTrackingScreenState extends State<HealthTrackingScreen> {
  List<Map<String, dynamic>> healthRecords = [];
  String rating = '';
  bool enoughSleep = false;
  String waterIntake = '';
  List<String> symptoms = [];
  bool wantToBookAppointment = false;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'STUDENT HEALTH TRACKING',
          style: TextStyle(color: Colors.indigo[300]),
        ),
        backgroundColor: Colors.tealAccent,
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/v870-tang-37.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Health Tracking Questions',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16.0),
                      _buildQuestion('Give a rating on your condition today',
                          ['VGood', 'Good', 'Average', 'Bad', 'VBad']),
                      const SizedBox(height: 16.0),
                      _buildQuestion(
                          'Do you have enough sleep?', ['Yes', 'No']),
                      const SizedBox(height: 16.0),
                      _buildQuestion(
                          'Do you drink enough water?', ['Yes', 'Maybe', 'No']),
                      const SizedBox(height: 16.0),
                      _buildSymptomsQuestion('Any of these symptoms today?', [
                        'Cough',
                        'Fever',
                        'Diarrhea',
                        'Sore Throat',
                        'Sneezing',
                        'Fatigue',
                        'Dizziness',
                        'Nothing'
                      ]),
                      const SizedBox(height: 16.0),
                      const Text('Health Tracking Questions',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16.0),
                      _buildTextQuestion('Do you want to book an appointment?'),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          const Text('Select Date:'),
                          const SizedBox(width: 16.0),
                          TextButton(
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );

                              if (pickedDate != null &&
                                  pickedDate != selectedDate) {
                                setState(() {
                                  selectedDate = pickedDate;
                                });
                              }
                            },
                            child: const Text(
                              'Choose Date',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Text(selectedDate.toLocal().toString().split(' ')[0]),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          _recordHealthData();
                          if (wantToBookAppointment) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AppointmentScreen(), // Navigate to Appointment Screen
                              ),
                            );
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text('Health Records',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo)),
              const SizedBox(height: 16.0),
              _buildHealthRecords(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion(String question, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(question, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8.0),
        Wrap(
          spacing: 8.0,
          children: options.map((option) {
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  if (question == 'Give a rating on your condition today') {
                    rating = option;
                  } else if (question == 'Do you have enough sleep?') {
                    enoughSleep = option == 'Yes';
                  } else if (question == 'Do you drink enough water?') {
                    waterIntake = option;
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: option ==
                        (question == 'Give a rating on your condition today'
                            ? rating
                            : (question == 'Do you have enough sleep?'
                                ? (enoughSleep ? 'Yes' : 'No')
                                : waterIntake))
                    ? Colors.green
                    : Colors.grey,
              ),
              child: Text(option),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSymptomsQuestion(String question, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(question, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8.0),
        Wrap(
          spacing: 8.0,
          children: options.map((option) {
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  if (symptoms.contains(option)) {
                    symptoms.remove(option);
                  } else {
                    symptoms.add(option);
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: symptoms.contains(option) ? Colors.green : Colors.grey,
              ),
              child: Text(option),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTextQuestion(String question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(question, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio(
              value: true,
              groupValue: wantToBookAppointment,
              onChanged: (value) {
                setState(() {
                  wantToBookAppointment = value as bool;
                });
              },
            ),
            const Text('Yes'),
            Radio(
              value: false,
              groupValue: wantToBookAppointment,
              onChanged: (value) {
                setState(() {
                  wantToBookAppointment = value as bool;
                });
              },
            ),
            const Text('No'),
          ],
        ),
      ],
    );
  }

  void _recordHealthData() {
    setState(() {
      healthRecords.add({
        'date': selectedDate,
        'rating': rating,
        'enoughSleep': enoughSleep,
        'waterIntake': waterIntake,
        'symptoms': symptoms.join(', '),
        'appointment': wantToBookAppointment ? 'Yes' : 'No',
      });
    });
  }

  Widget _buildHealthRecords() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: healthRecords.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(healthRecords[index]['date'].toString()),
          onDismissed: (direction) {
            setState(() {
              healthRecords.removeAt(index);
            });
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 36,
            ),
          ),
          child: Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(
                  'Date: ${healthRecords[index]['date'].toLocal().toString().split(' ')[0]}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Rating: ${healthRecords[index]['rating']}'),
                  Text(
                      'Enough Sleep: ${healthRecords[index]['enoughSleep'] ? 'Yes' : 'No'}'),
                  Text('Water Intake: ${healthRecords[index]['waterIntake']}'),
                  Text('Symptoms: ${healthRecords[index]['symptoms']}'),
                  Text(
                      'Appointment Booking: ${healthRecords[index]['appointment']}'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
