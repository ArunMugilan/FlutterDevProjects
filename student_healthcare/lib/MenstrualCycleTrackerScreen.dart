import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenstruationCycleTrackerScreen extends StatefulWidget {
  @override
  _MenstruationCycleTrackerScreenState createState() =>
      _MenstruationCycleTrackerScreenState();
}

class _MenstruationCycleTrackerScreenState
    extends State<MenstruationCycleTrackerScreen> {
  List<DateTime> menstruationDates = [];
  DateTime selectedDate = DateTime.now();

  void _addMenstruationDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      menstruationDates.add(selectedDate);
      prefs.setStringList(
        'menstruationDates',
        menstruationDates.map((date) => date.toString()).toList(),
      );
    });
  }

  void _seeDetails(int index) {
    DateTime currentDate = menstruationDates[index];
    DateTime nextDate =
        currentDate.add(const Duration(days: 28)); // Assuming a 28-day cycle

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Details for Menstruation Date'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Current Menstruation Date: ${currentDate.toLocal().toString().split(' ')[0]}'),
              Text(
                  'Next Probable Menstruation Date: ${nextDate.toLocal().toString().split(' ')[0]}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _editMenstruationDate(int index) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: menstruationDates[index],
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        menstruationDates[index] = pickedDate;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList(
        'menstruationDates',
        menstruationDates.map((date) => date.toString()).toList(),
      );
    }
  }

  void _deleteMenstruationDate(int index) async {
    setState(() {
      menstruationDates.removeAt(index);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      'menstruationDates',
      menstruationDates.map((date) => date.toString()).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MENSTRUAL CYCLE TRACKER',
          style: TextStyle(color: Colors.indigo[300]),
        ),
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
            children: [
              Row(
                children: [
                  const Text('Select Menstruation Date:', style: TextStyle(fontWeight: FontWeight.bold),),
                  const SizedBox(width: 16.0),
                  TextButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
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
                onPressed: () {
                  _addMenstruationDate();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent, // Set the button color to teal
                ),
                child: const Text('Add Menstruation Date', style: TextStyle(color: Colors.indigo),),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: FutureBuilder<List<DateTime>>(
                  future: SharedPreferences.getInstance().then((prefs) {
                    List<String>? storedDates =
                        prefs.getStringList('menstruationDates');
                    if (storedDates != null) {
                      return storedDates.map((e) => DateTime.parse(e)).toList();
                    } else {
                      return [];
                    }
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            _deleteMenstruationDate(index);
                          },
                          background: Container(
                            alignment: AlignmentDirectional.centerEnd,
                            color: Colors.red,
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          child: Card(
                            child: ListTile(
                              title: Text(
                                  'Menstruation Date: ${snapshot.data![index].toLocal().toString().split(' ')[0]}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _editMenstruationDate(index);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.info),
                                    onPressed: () {
                                      _seeDetails(index);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
