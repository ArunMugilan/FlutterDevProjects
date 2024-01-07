import 'package:flutter/material.dart';

class TipsAndTricksScreen extends StatefulWidget {
  @override
  _TipsAndTricksScreenState createState() => _TipsAndTricksScreenState();
}

class _TipsAndTricksScreenState extends State<TipsAndTricksScreen> {
  Map<String, bool> expandedStates = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'STUDENT HEALTH TIPS & TRICKS',
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 5,
              color: Colors.tealAccent,
              child: Column(
                children: [
                  buildCategory('Health Care', [
                    'Get regular exercise to maintain overall health.',
                    'Ensure sufficient sleep for better productivity.',
                    'Stay hydrated throughout the day.',
                    'Manage stress through relaxation techniques.',
                  ]),
                  const SizedBox(height: 10,),
                  buildCategory('Proper Food Intake', [
                    'Include a variety of fruits and vegetables in your diet.',
                    'Consume lean proteins for muscle health.',
                    'Limit processed and sugary foods.',
                    'Control portion sizes to maintain a healthy weight.',
                  ]),
                  const SizedBox(height: 10,),
                  buildCategory('Tips When Not Feeling Well', [
                    'Stay hydrated with water, herbal teas, or broths.',
                    'Rest and allow your body time to recover.',
                    'Consult a healthcare professional if symptoms persist.',
                    'Avoid self-medication without proper advice.',
                  ]),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }

  Widget buildCategory(String title, List<String> content) {
    return ExpansionTile(
      title: Text(title),
      initiallyExpanded: expandedStates[title] ?? false,
      onExpansionChanged: (isExpanded) {
        setState(() {
          expandedStates[title] = isExpanded;
        });
      },
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: content.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print('Clicked: ${content[index]}');
              },
              child: Card(
                color: Colors.blueGrey[100],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    content[index],
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
