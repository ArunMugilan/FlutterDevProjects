import 'package:flutter/material.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _applyForAppointment() {
    print('Name: ${nameController.text}');
    print('Reason for Appointment: ${reasonController.text}');
    print('Selected Date: $selectedDate');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Appointment Registered'),
        content:
            const Text('You will be notified once your appointment is confirmed.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'APPOINTMENT',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Your Name'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: reasonController,
                decoration:
                    const InputDecoration(labelText: 'Reason for Appointment'),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Text('Select Date:', style: TextStyle(fontWeight: FontWeight.bold),),
                  const SizedBox(width: 16.0),
                  TextButton(
                    onPressed: _selectDate,
                    child: const Text(
                      'Choose Date',
                      style: TextStyle(color: Colors.indigo),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Text(selectedDate.toLocal().toString().split(' ')[0]),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _applyForAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                ),
                child: const Text('Apply for Appointment', style: TextStyle(color: Colors.indigo),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
