import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_parking/models/complaint.dart';
import 'package:smart_parking/themes/ColourThemes.dart';

class ComplaintPage extends StatefulWidget {
  @override
  _ComplaintPageState createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final _formKey = GlobalKey<FormState>();
  final _complaintController = TextEditingController();
  final List<Complaint> _complaints = [];

  @override
  void initState() {
    super.initState();
    _fetchComplaints();
  }

  Future<void> _fetchComplaints() async {
    final url = Uri.https(
        'smartparkingappdb-default-rtdb.asia-southeast1.firebasedatabase.app',
        'complaints.json');

    try {
      final response = await http.get(url);
      final Map<String, dynamic> data = json.decode(response.body);
    // print(response.body);
      final List<Complaint> loadedComplaints = [];

      data.forEach((complaintId, complaintData) {
        print(complaintData['complaint']);
        print(complaintData['status']);
        print(complaintData['review']);
        loadedComplaints.add(Complaint(
          id: complaintId,
          complaint: complaintData['complaint'],
          status: complaintData['status'],
          review: complaintData['review'].toString(),
        ));
      });

      setState(() {
        _complaints.clear();
        _complaints.addAll(loadedComplaints);
      });
    } catch (error) {
      print('Error fetching complaints: $error');
    }
  }

  Future<void> _addComplaint(String complaintText) async {
    final url = Uri.https(
        'smartparkingappdb-default-rtdb.asia-southeast1.firebasedatabase.app',
        'complaints.json');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'complaint': complaintText,
        'status': 'Pending',
        'review': '',
      }),
    );

    print(response.body);
    print(response.statusCode);

    _fetchComplaints();
  }

  Future<void> _updateComplaint(String id, String reviewText) async {
    final url = Uri.https(
        'smartparkingappdb-default-rtdb.asia-southeast1.firebasedatabase.app',
        'complaints.json');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'review': reviewText,
        'status': 'Reviewed',
      }),
    );

    print(response.body);
    print(response.statusCode);

    _fetchComplaints();
  }

  Future<void> _deleteComplaint(String id) async {
    final url = Uri.https(
        'smartparkingappdb-default-rtdb.asia-southeast1.firebasedatabase.app',
        'complaints.json');
    final response = await http.delete(url);

    print(response.body);
    print(response.statusCode);

    _fetchComplaints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c2,
      appBar: AppBar(
        backgroundColor: c2,
        elevation: 0,
        title: Text('Complaints', style: TextStyle(color: c1)),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: c1,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            );
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                _fetchComplaints();
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.black,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _complaintController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your complaint';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Type your complaint here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addComplaint(_complaintController.text);
                  _complaintController.clear();
                }
              },
              style: OutlinedButton.styleFrom(backgroundColor: c3),
              child: Text('Submit', style: TextStyle(color: c1)),
            ),
            const SizedBox(height: 16),
            Expanded(
                child: _complaints.isNotEmpty
                    ? ListView.builder(
                        itemCount: _complaints.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(_complaints[index].complaint),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Status: ${_complaints[index].status}'),
                                  if (_complaints[index].status == 'Reviewed')
                                    Text(
                                        'Review: ${_complaints[index].review}'),
                                ],
                              ),
                              trailing: Wrap(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _showEditDialog(_complaints[index]);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      _deleteComplaint(_complaints[index].id);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text('No complaints available'),
                      )),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(Complaint complaint) {
    TextEditingController reviewController =
        TextEditingController(text: complaint.review);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Complaint'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Complaint: ${complaint.complaint}'),
              const SizedBox(height: 8),
              TextFormField(
                controller: reviewController,
                decoration: const InputDecoration(
                  labelText: 'Review',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateComplaint(complaint.id, reviewController.text);
                Navigator.pop(context);
              },
              child: const Text('Save Review & Update'),
            ),
          ],
        );
      },
    );
  }
}
